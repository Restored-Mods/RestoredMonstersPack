local mod = RestoredMonsterPack
local game = Game()



function mod:bloodwormUpdate(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Bloodworm") then
		local sprite = entity:GetSprite()
		local data = entity:GetData()
		local target = entity:GetPlayerTarget()
		local room = game:GetRoom()


		-- Go to a new location if the current one is too close to the walls
		if entity.Position.X < room:GetTopLeftPos().X + 40 or entity.Position.Y < room:GetTopLeftPos().Y + 40
		or entity.Position.X > room:GetBottomRightPos().X - 40 or entity.Position.Y > room:GetBottomRightPos().Y - 40 then
			entity.State = NpcState.STATE_MOVE
		end
		if entity.State == NpcState.STATE_MOVE then
			entity.Visible = false
		else
			entity.Visible = true
		end


		-- Get starting position
		if sprite:IsEventTriggered("GetPos") then
			data.shootAngle = (target.Position - entity.Position):GetAngleDegrees()
			entity:PlaySound(SoundEffect.SOUND_ANGRY_GURGLE, 1.25, 0, false, 1)

		-- Shoot laser
		elseif sprite:IsEventTriggered("StartLaser") and game:GetRoom():CheckLine(entity.Position, target.Position, 3, 0, false, false) and entity.Position:Distance(target.Position) <= 600 then
			local rotateDir = 1
			if (target.Position - entity.Position):GetAngleDegrees() <= data.shootAngle then
				rotateDir = -1
			end

			local laser_ent_pair = {laser = EntityLaser.ShootAngle(1, entity.Position, data.shootAngle - (rotateDir * 45), -1, Vector(0, entity.SpriteScale.Y * -16), entity), entity}
			data.brim = laser_ent_pair.laser
			entity.State = NpcState.STATE_IDLE
			data.brim:SetActiveRotation(32, rotateDir * 90, rotateDir * 2.25, 5)
			data.brim.Visible = false
			data.startFrame = entity.FrameCount

			SFXManager():Play(SoundEffect.SOUND_BOSS_GURGLE_ROAR, 1, 0, false, 0.96, 0)
			sprite.FlipX = false

		elseif sprite:IsEventTriggered("StopLoop") then
			entity.State = NpcState.STATE_JUMP
			data.brim = nil


		elseif sprite:IsEventTriggered("Horn") or sprite:IsEventTriggered("Appear") then
			for i = 0, 4 do
				local rocks = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, entity.Position, Vector.FromAngle(math.random(0, 359)) * 3, entity):ToEffect()
				rocks:GetSprite():Play("rubble", true)
				rocks.State = 2
			end

			local volume = 1
			if sprite:IsEventTriggered("Horn") then
				if target.Position.X < entity.Position.X then
					sprite.FlipX = true
				else
					sprite.FlipX = false
				end

			elseif sprite:IsEventTriggered("Appear") then
				SFXManager():Play(SoundEffect.SOUND_GOOATTACH0, 1.25)
				volume = 0.75
			end

			SFXManager():Play(SoundEffect.SOUND_ROCK_CRUMBLE, volume)
		end


		if data.brim then
			if not data.brim:Exists() then
				if not sprite:IsPlaying("AttackEnd") then
					sprite:Play("AttackEnd", true)
					sprite.FlipX = data.endFlip
				end

			else
				local angleDegrees = (data.brim.EndPoint - entity.Position):GetAngleDegrees()
				data.brim.DepthOffset = entity.DepthOffset + 1

				if data.startFrame and entity.FrameCount == data.startFrame + 2 then
					data.brim.Visible = true
					SFXManager():Play(SoundEffect.SOUND_BLOOD_LASER)
				end

				-- Get animation direction
				if angleDegrees > -45 and angleDegrees < 45 then
					data.facing = "Right"
					data.endFlip = false
				elseif angleDegrees >= 45 and angleDegrees <= 135 then
					data.facing = "Down"
				elseif angleDegrees < -45 and angleDegrees > -135 then
					data.facing = "Up"
					data.brim.DepthOffset = entity.DepthOffset - 1
				else
					data.facing = "Left"
					data.endFlip = true
				end

				if not sprite:IsPlaying("AttackLoop" .. data.facing) then
					sprite:SetAnimation("AttackLoop" .. data.facing, false)
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.bloodwormUpdate, EntityType.ENTITY_ROUND_WORM)