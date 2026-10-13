-- server side!

-- npc
local rig = workspace.TestNPC  -- script is actually parented to the rig, you can change it if you want
local humanoid = rig.Humanoid

-- animations
local animation = rig.Animate.run.RunAnim

local animator = humanoid.Animator
local walkTrack = animator:LoadAnimation(animation)

-- path finding service
local PathFindingService = game:GetService("PathfindingService")
local path = PathFindingService:CreatePath(
	{
		AgentCanJump = true,
		AgentRadius = 0.5,
	}
)

-- functioning
while true do
	local targetPos = Vector3.new(math.random(-57, 48), 1, math.random(-36, 53))
	
	local success, error = pcall(function()
		path:ComputeAsync(rig.PrimaryPart.Position, targetPos)
	end)
	
	if success then
		walkTrack:Play()
		walkTrack.Looped = true
		
		for _, waypoint in ipairs(path:GetWaypoints()) do
			
			-- waypoint part
			local wayPart = Instance.new("Part", workspace) -- for test
			wayPart.Material = "Neon"
			wayPart.Anchored = true
			wayPart.Shape = "Ball"
			wayPart.Color = Color3.new(1, 1, 1)
			wayPart.Position = waypoint.Position
			wayPart.Size = Vector3.new(1, 1, 1)
			wayPart.CanCollide = false
			
			-- waypoint part highlight
			local highlight = Instance.new("Highlight", wayPart)
			highlight.Adornee = wayPart
			highlight.OutlineColor = Color3.new(0, 0, 0)
			highlight.DepthMode = Enum.HighlightDepthMode.Occluded
			highlight.FillTransparency = 1
			
			task.delay(1.2, function()
				wayPart:Destroy()
			end)
			
			-- path finding service
			if waypoint.Action == Enum.PathWaypointAction.Jump then
				humanoid.Jump = true
			end
			
			humanoid:MoveTo(waypoint.Position)
			humanoid.MoveToFinished:Wait()
		end
		walkTrack:Stop()
		walkTrack.Looped = false
	end
end