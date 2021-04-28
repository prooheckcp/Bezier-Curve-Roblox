--Services||
local TweenService = game:GetService("TweenService")
----------||


local function quadraticBezier(p0, p1, p2, t, pFinal)

	local holder = {X = 0, Y = 0, Z = 0}

	holder.X = math.pow(1 - t, 2) * p0.X + 
		(1 - t) * 2 * t * p1.X +
		t * t * p2.X

	holder.Y = math.pow(1 - t, 2) * p0.Y + 
		(1 - t) * 2 * t * p1.Y +
		t * t * p2.Y

	holder.Z = math.pow(1 - t, 2) * p0.Z + 
		(1 - t) * 2 * t * p1.Z +
		t * t * p2.Z

	return Vector3.new(holder.X, holder.Y, holder.Z)
end


function moveObject(p0, p1, p2, precision, T, object)
	
	--Creates the points
	local translatePoints = {}
	
	for t = 0, 1, precision do
		table.insert(translatePoints, quadraticBezier(p0, p1, p2, t))
	end
	
	--Get the last point
	table.insert(translatePoints, p2)
	
	--Generate tween
	local tweenInfo = TweenInfo.new(T/(#translatePoints - 1))
	local tweenInstances = {}
	for _, v in pairs(translatePoints)do
		table.insert(tweenInstances ,TweenService:Create(object, tweenInfo, {Position = v}))
	end

	local function playMovement(index)
		
		if #translatePoints < index then
			return
		end
		
		local tweenInstance = tweenInstances[index]
		
		tweenInstance.Completed:Connect(function()
			playMovement(index + 1)
		end)
		tweenInstance:Play()
	end
	
	playMovement(1)
	
end

return moveObject


