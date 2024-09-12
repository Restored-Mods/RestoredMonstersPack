local mod = RestoredMonsterPack
local game = Game()

local Settings = {
	Cooldown = 45,
	CanarySpeed = 0.65,
	ForeignerSpeed = 0.525,
	FrontRange = 360,
	SideRange = 26,
	BrimDuration = 30,
	CoalAmount = 3
}

local States = {
	Appear = 0,
	Moving = 1,
	Attacking = 2
}

local canaryvar = Isaac.GetEntityVariantByName("​Canary")
local foreigar = Isaac.GetEntityVariantByName("​Foreigner")


function mod:canaryInit(entity)
	local data = entity:GetData()
	local level = game:GetLevel()

	entity:ToNPC()
	entity:AddEntityFlags(EntityFlag.FLAG_APPEAR)
	entity.ProjectileCooldown = Settings.Cooldown
	data.state = States.Appear
	data.place = Isaac:GetRandomPosition()

	-- Gehenna skins
	if (level:GetStage() == LevelStage.STAGE3_1 or level:GetStage() == LevelStage.STAGE3_2) and level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B then
		local champ = ""
		if entity:IsChampion() then
			champ = "_champion"
		end

		local sprite = entity:GetSprite()
		if entity.Variant == canaryvar then
			sprite:ReplaceSpritesheet(0, "gfx/monsters/restored/canary/bodies_mines_gehenna" .. champ .. ".png")
			sprite:ReplaceSpritesheet(1, "gfx/monsters/restored/canary/canary_gehenna" .. champ .. ".png")
			sprite:ReplaceSpritesheet(4, "gfx/effects/lighting_eye_red.png")

		elseif entity.Variant == foreigar then
			sprite:ReplaceSpritesheet(0, "gfx/monsters/restored/canary/danny_body_gehenna" .. champ .. ".png")
			sprite:ReplaceSpritesheet(1, "gfx/monsters/restored/canary/foreigner_gehenna" .. champ .. ".png")
			sprite:ReplaceSpritesheet(2, "gfx/monsters/restored/canary/foreigner_gehenna" .. champ .. ".png")
			sprite:ReplaceSpritesheet(3, "gfx/monsters/restored/canary/foreigner_lighting_gehenna.png")
		end
		sprite:LoadGraphics()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.canaryInit, EntityType.ENTITY_CANARY)

function mod:canaryUpdate(entity)
	local sprite = entity:GetSprite()
	local data = entity:GetData()
	local target = entity:GetPlayerTarget()
	local room = game:GetRoom()


	if data.state == States.Appear or data.state == nil then
		data.state = States.Moving


	elseif data.state == States.Moving then
		local speed = Settings.CanarySpeed
		if entity.Variant == foreigar then
			speed = Settings.ForeignerSpeed
		end

		-- Movement
		if entity.Position:Distance(data.place) < 2 or entity.Velocity:Length() < 1 or not entity.Pathfinder:HasPathToPos(data.place, false) then
			data.place = Isaac:GetRandomPosition()
		end
		entity.Pathfinder:FindGridPath(data.place, speed, 500, false)
		entity.Pathfinder:UpdateGridIndex()


		-- Get animation direction
		local angleDegrees = entity.Velocity:GetAngleDegrees()
		if angleDegrees > -45 and angleDegrees < 45 then
			data.facing = "Right"
		elseif angleDegrees >= 45 and angleDegrees <= 135 then
			data.facing = "Down"
		elseif angleDegrees < -45 and angleDegrees > -135 then
			data.facing = "Up"
		else
			data.facing = "Left"
		end


		-- Walking animation
		if entity.Velocity:Length() > 0.1 then
			if not sprite:IsPlaying("Walk" .. data.facing) then
				sprite:Play("Walk" .. data.facing, true)
			end
		else
			sprite:SetFrame("WalkDown", 0)
		end


		-- Shoot laser
		if entity.ProjectileCooldown <= 0 then
			local mode = entity.Variant == canaryvar and 3 or 2
			if game:GetRoom():CheckLine(entity.Position, target.Position, mode, 0, false, false) then   -- 3 - entity.Variant
				if data.facing == "Left" or data.facing == "Right" then
					if entity.Position.Y <= target.Position.Y + Settings.SideRange and entity.Position.Y >= target.Position.Y - Settings.SideRange then
						if data.facing == "Left" and target.Position.X > (entity.Position.X - Settings.FrontRange) and target.Position.X < entity.Position.X
						or data.facing == "Right" and target.Position.X < (entity.Position.X + Settings.FrontRange) and target.Position.X > entity.Position.X then
							data.state = States.Attacking
						end
					end

				elseif data.facing == "Up" or data.facing == "Down" then
					if entity.Position.X <= target.Position.X + Settings.SideRange and entity.Position.X >= target.Position.X - Settings.SideRange then
						if data.facing == "Up" and target.Position.Y > (entity.Position.Y - Settings.FrontRange) and target.Position.Y < entity.Position.Y
						or data.facing == "Down" and target.Position.Y < (entity.Position.Y + Settings.FrontRange) and target.Position.Y > entity.Position.Y then
							data.state = States.Attacking
						end
					end
				end
			end

		else
			entity.ProjectileCooldown = entity.ProjectileCooldown - 1
		end


	elseif data.state == States.Attacking then
		entity.Velocity = Vector.Zero
		entity.ProjectileCooldown = Settings.Cooldown

		-- Canary laser
		if entity.Variant == canaryvar then
			-- Get angles and offsets
			local angle = 0
			local depth = entity.DepthOffset - 1
			local xoffset = 4

			if data.facing == "Left" then
				angle = 180
				depth = entity.DepthOffset + 1
				xoffset = -4

			elseif data.facing == "Up" then
				angle = -90
				xoffset = -12

			elseif data.facing == "Down" then
				angle = 90
				depth = entity.DepthOffset + 1
				xoffset = 12
			end

			-- Animation, sounds and tracer
			if not sprite:IsPlaying("Attack" .. data.facing) then
				sprite:Play("Attack" .. data.facing, true)
				entity:PlaySound(SoundEffect.SOUND_WORM_SPIT, 1.4, 0, false, 0.95)
				sprite.PlaybackSpeed = 0.9

				local tracer = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GENERIC_TRACER, 0, entity.Position + (Vector.FromAngle(angle) * 10) + Vector(xoffset, -10), Vector.Zero, entity):ToEffect()
				tracer.LifeSpan = 5
				tracer.Timeout = 1
				tracer.TargetPosition = Vector.FromAngle(angle)
				tracer:GetSprite().Color = Color(1,0.2,0, 0.2)
			end
			if sprite:GetFrame() == 21 then
				data.state = States.Moving
			end

			-- Laser
			if sprite:IsEventTriggered("Shoot") then
				local laser_ent_pair = {laser = EntityLaser.ShootAngle(2, entity.Position, angle, 3, Vector(entity.SpriteScale.X * xoffset, entity.SpriteScale.Y * -29), entity), entity}
				local _, endPos = room:CheckLine(entity.Position, entity.Position * (Vector.FromAngle(angle) * 100), 3)
				laser_ent_pair.laser:SetMaxDistance(entity.Position:Distance(endPos + Vector(entity.SpriteScale.X * xoffset, entity.SpriteScale.Y * 29)))

				laser_ent_pair.laser.DepthOffset = depth
				laser_ent_pair.laser:SetColor(Color(1,1,1, 1, 0.08,0.24,0.16), 0, 1, false, false)

				SFXManager():Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_STRONG)
				SFXManager():Stop(SoundEffect.SOUND_REDLIGHTNING_ZAP)
				sprite.PlaybackSpeed = 1
			end


		-- Foreigner laser
		elseif entity.Variant == foreigar then
			if not data.brim then
				-- Get angles and offsets
				local angle = 0
				local depth = 200
				local xoffset = 0
				local yoffset = -24

				if data.facing == "Left" then
					angle = 180
					xoffset = -14

				elseif data.facing == "Up" then
					angle = -90
					depth = entity.DepthOffset - 1
					yoffset = -32

				elseif data.facing == "Right" then
					xoffset = 14

				elseif data.facing == "Down" then
					angle = 90
					yoffset = -36
				end

				-- Animation, sounds and tracer
				if not sprite:IsPlaying("Attack" .. data.facing) then
					sprite:Play("Attack" .. data.facing, true)
					entity:PlaySound(SoundEffect.SOUND_ANGRY_GURGLE, 1.4, 0, false, 1)

					local tracer = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GENERIC_TRACER, 0, entity.Position + (Vector.FromAngle(angle) * 10) + Vector(xoffset, -6), Vector.Zero, entity):ToEffect()
					tracer.LifeSpan = 15
					tracer.Timeout = 1
					tracer.TargetPosition = Vector.FromAngle(angle)
					tracer:GetSprite().Color = Color(1,0.2,0, 0.25)
					tracer.SpriteScale = Vector(2, 0)
				end

				if sprite:IsEventTriggered("Shoot") then
					-- Guide laser
					local guide_ent_pair = {glaser = EntityLaser.ShootAngle(1, entity.Position, angle, Settings.BrimDuration, Vector.Zero, entity), entity}
					data.guide = guide_ent_pair.glaser
					data.guide.Visible = false
					data.guide:GetData().hot = true
					data.guide.CollisionDamage = 0
					data.guide.Mass = 0
					data.guide.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS  -- PLEASE MAKE PROPER SPRITE OFFSETS FOR LASERS


					-- Fire brimstone
					local laser_ent_pair = {laser = EntityLaser.ShootAngle(1, entity.Position, angle, Settings.BrimDuration, Vector(entity.SpriteScale.X * xoffset, entity.SpriteScale.Y * yoffset), entity), entity}
					data.brim = laser_ent_pair.laser

					data.brim.DepthOffset = depth
					SFXManager():Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_STRONG, 1.2, 0, false, 0.7)

					-- Fire brimstone visuals

					data.brim:GetData().hot = true
					local laserSprite = data.brim:GetSprite()
          laserSprite:Load("gfx/effects/thick_red_laser.anm2",true)
					laserSprite:Play("HotBrim", true)
					laserSprite:ReplaceSpritesheet(0, "gfx/effects/hotbrimstone.png")
					laserSprite:ReplaceSpritesheet(1, "gfx/effects/hotbrimstone.png")
					laserSprite:LoadGraphics()

					-- Awful workaround for them not flickering when spawning
					data.brim:SetMaxDistance(1)
					data.brim.Visible = false
					data.startFrame = entity.FrameCount
				end

			else
				if not data.brim:Exists() then
					if not sprite:IsPlaying("Attack" .. data.facing .. "End") then
						sprite:Play("Attack" .. data.facing .. "End", true)
					end
					if sprite:GetFrame() == 7 then
						data.state = States.Moving
						data.brim = nil
					end

				else
					if not sprite:IsPlaying("Attack" .. data.facing .. "Loop") then
						sprite:Play("Attack" .. data.facing .. "Loop", true)
					end

					if data.startFrame and entity.FrameCount == data.startFrame + 2 then
						data.brim.Visible = true
						SFXManager():Play(SoundEffect.SOUND_BLOOD_LASER)
					end

					-- Destroy obstacles hit by the laser
					local hitgrid = room:GetGridEntityFromPos(data.guide:GetEndPoint() + (Vector.FromAngle(data.brim.Angle) * 10))
					if hitgrid and hitgrid.CollisionClass > 1 and hitgrid:GetType() ~= GridEntityType.GRID_WALL then
						local extra = 0
						if data.facing == "Down" then
							extra = 40
						end
						data.brim:SetMaxDistance(data.guide:GetEndPoint():Distance(entity.Position + data.brim.ParentOffset) + extra)

						if (hitgrid.CollisionClass == GridCollisionClass.COLLISION_SOLID and hitgrid:GetType() ~= GridEntityType.GRID_ROCKB) or hitgrid:GetType() == GridEntityType.GRID_TNT then
							if not data.gridtimer then
								data.gridtimer = 18
							end
							if data.gridtimer > 0 then
								hitgrid:GetSprite().Color = Color.Lerp(hitgrid:GetSprite().Color, Color(1,1,1, 1, 0.40,0.20,0), 0.1)
								data.gridtimer = data.gridtimer - 1
							else
								hitgrid:Destroy()
								Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_JET, 0, hitgrid.Position, Vector.Zero, entity)
								for i = 0, Settings.CoalAmount - 1 do
									Isaac.Spawn(EntityType.ENTITY_FIREPLACE, 11, 0, hitgrid.Position + Vector(math.random(-20, 20), math.random(-20, 20)), Vector.Zero, entity) -- Coal
								end
								data.gridtimer = nil
							end
						end
					elseif data.brim.FrameCount >= 2 then
						data.brim:SetMaxDistance(0)
					end
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.canaryUpdate, EntityType.ENTITY_CANARY)



-- Foreigner laser impact
function mod:foreignerLaserImpact(effect)
	if effect.Parent and effect.Parent:GetData().hot == true then
		local sprite = effect:GetSprite()

		sprite.Color = Color(1,1,1, 1, 0,0.32,0)
		sprite:ReplaceSpritesheet(0, "gfx/effects/hotbrimstone_impact.png")
		sprite:LoadGraphics()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.foreignerLaserImpact, EffectVariant.LASER_IMPACT)

-- Foreigner laser shouldn't hurt certain entities, should ignite ignitable enemies
function mod:foreignerLaserDMG(target, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	if (damageSource.Entity and damageSource.Entity.Type == EntityType.ENTITY_CANARY and damageSource.Entity.Variant == foreigar and damageSource.Entity:GetData().brim) then
		if ((target.Type == EntityType.ENTITY_CLOTTY and (target.Variant == 0 or target.Variant == 3)) or (target.Type == EntityType.ENTITY_HOPPER and target.Variant == 0) or target.Type == EntityType.ENTITY_FIREPLACE
		or target.Type == EntityType.ENTITY_FLAMINGHOPPER or (target.Type == EntityType.ENTITY_ROCK_SPIDER and target.Variant ~= 1) or target.Type == EntityType.ENTITY_GYRO) then
			if (target.Type == EntityType.ENTITY_CLOTTY or target.Type == EntityType.ENTITY_HOPPER or target.Type == EntityType.ENTITY_ROCK_SPIDER or target.Type == EntityType.ENTITY_GYRO) and target.Variant == 0 then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_JET, 0, target.Position, Vector.Zero, damageSource.Entity)
				SFXManager():Play(SoundEffect.SOUND_FIREDEATH_HISS)
			end
			return false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.foreignerLaserDMG)