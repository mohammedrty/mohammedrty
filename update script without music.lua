-- سكربت Blox Fruits المتكامل -- الإصدار 1.6 المعدل
-- تم التعديل ليعمل على Delta Executor 2.666+

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- تعريف متغيرات getgenv() لضمان التوافق
getgenv().AutoFarmEnabled = false
getgenv().FruitRainEnabled = false

-- تحميل المكتبة مع حلول بديلة
local Rayfield, Library
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/slretta/Rayfield/main/source.lua'))()
end)

if not success then
    warn("فشل تحميل المكتبة: "..err)
    -- بديل إذا فشل Rayfield
    Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua'))()
end

-- فحص اللعبة
local validGames = {
    [2753915549] = true, -- Blox Fruits الأولى
    [4442272183] = true, -- Blox Fruits الثانية
    [7449423635] = true  -- Blox Fruits الثالثة
}

if not validGames[game.PlaceId] then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "خطأ",
        Text = "هذا السكربت يعمل فقط في لعبة Blox Fruits",
        Duration = 10,
        Button1 = "حسناً"
    })
    return
end

-- إنشاء الواجهة مع دعم متعدد المكتبات
local Window
if Rayfield then
    Window = Rayfield:CreateWindow({
        Name = "Blox Fruits Pro - الإصدار العربي المعدل",
        LoadingTitle = "جاري التهيئة...",
        LoadingSubtitle = "النسخة 1.6 - معدلة ل Delta Executor",
        ConfigurationSaving = { Enabled = true, FolderName = "BloxFruitsConfig", FileName = "DeltaConfig" }
    })
elseif Library then
    Window = Library.CreateLib("Blox Fruits Pro - الإصدار العربي المعدل", "DarkTheme")
end

-- ========= تبويب الزراعة الذكية (معدل) =========
local FarmTab = Window:CreateTab("الزراعة التلقائية", "rbxassetid://4483345998")

local AutoFarmToggle = FarmTab:CreateToggle({
    Name = "تفعيل الزراعة التلقائية",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        getgenv().AutoFarmEnabled = Value
        if Value then
            spawn(function()
                while getgenv().AutoFarmEnabled do
                    pcall(function()
                        -- نظام البحث عن الأعداء المعدل
                        local closestEnemy, minDistance
                        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                                local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                                if not minDistance or distance < minDistance then
                                    minDistance = distance
                                    closestEnemy = enemy
                                end
                            end
                        end

                        -- نظام الهجوم المعدل
                        if closestEnemy and minDistance < 50 then
                            -- حركة أكثر طبيعية
                            local humanoid = game.Players.LocalPlayer.Character.Humanoid
                            humanoid:MoveTo(closestEnemy.HumanoidRootPart.Position + Vector3.new(math.random(-3,3), 0, math.random(-3,3)))
                            
                            -- هجوم متغير
                            local attacks = {"Z", "X", "C", "V"}
                            local randomAttack = attacks[math.random(1, #attacks)]
                            keypress(randomAttack:byte())
                            task.wait(0.1)
                            keyrelease(randomAttack:byte())
                            
                            -- استراحة عشوائية
                            if math.random(1, 10) > 7 then
                                task.wait(math.random(0.1, 0.5))
                            end
                        end
                    end)
                    task.wait(0.3)
                end
            end)
        end
    end
})

-- ========= تبويب التنقل بين الجزر (معدل) =========
local TeleportTab = Window:CreateTab("نظام التنقل", "rbxassetid://7733918325")

local IslandLocations = {
    ["جزيرة الغابة"] = CFrame.new(-1600, 37, 150),
    ["القرية القرصنة"] = CFrame.new(-1181, 4, 3805),
    ["الصحراء"] = CFrame.new(944, 6, 4193),
    ["جزيرة الثلج"] = CFrame.new(1348, 8, -1321),
    ["مارينفورد"] = CFrame.new(-4485, 20, 1950)
}

-- نظام بديل لـ table.keys
local islandNames = {}
for k in pairs(IslandLocations) do table.insert(islandNames, k) end

local IslandDropdown = TeleportTab:CreateDropdown({
    Name = "اختر وجهتك",
    Options = islandNames,
    CurrentOption = "جزيرة الغابة",
    Flag = "IslandSelection",
    Callback = function(Option)
        local targetCFrame = IslandLocations[Option]
        if targetCFrame then
            pcall(function()
                -- نظام تنقل أكثر أماناً
                local character = game.Players.LocalPlayer.Character
                if character then
                    local tween = game:GetService("TweenService"):Create(
                        character.HumanoidRootPart,
                        TweenInfo.new(1, Enum.EasingStyle.Linear),
                        {CFrame = targetCFrame}
                    )
                    tween:Play()
                end
            end)
        end
    end
})

-- ========= نظام Fruit Rain المعدل =========
local FruitTab = Window:CreateTab("نظام Fruit Rain", "rbxassetid://7733960981")

local AllFruits = {
    "Bomb", "Spike", "Chop", "Spring", "Smoke", "Flame", "Falcon", "Ice", "Sand", 
    "Dark", "Diamond", "Light", "Rubber", "Barrier", "Ghost", "Magma", "Quake", 
    "Buddha", "Love", "Spider", "Sound", "Phoenix", "Portal", "Rumble", "Pain", 
    "Blizzard", "Gravity", "Mammoth", "Dough", "Shadow", "Venom", "Control", 
    "Spirit", "Dragon", "Leopard", "Kitsune"
}

local FruitRainToggle = FruitTab:CreateToggle({
    Name = "تفعيل Fruit Rain الشامل",
    CurrentValue = false,
    Flag = "FruitRainToggle",
    Callback = function(Value)
        getgenv().FruitRainEnabled = Value
        if Value then
            spawn(function()
                while getgenv().FruitRainEnabled do
                    pcall(function()
                        -- نظام شراء الفواكه المعدل
                        local randomFruit = AllFruits[math.random(1, #AllFruits)]
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy", randomFruit)
                        
                        -- نظام جذب الفواكه المعدل
                        for _, item in pairs(workspace:GetChildren()) do
                            if item.Name == "Fruit" and item:FindFirstChild("Handle") then
                                local randomOffset = Vector3.new(math.random(-5,5), math.random(0,3), math.random(-5,5))
                                item.Handle.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(randomOffset)
                                
                                -- تأثيرات خاصة للفواكه النادرة
                                if table.find({"Dragon","Leopard","Kitsune"}, item.Fruit.Value) then
                                    item.Handle.Velocity = Vector3.new(0, -10, 0)
                                end
                            end
                        end
                    end)
                    task.wait(0.7) -- تقليل السرعة لتجنب التباطؤ
                end
            end)
        end
    end
})

FruitTab:CreateLabel("ملاحظة: تحتاج إلى 2,500$ لكل فاكهة")

-- ========= نظام الموسيقى المعدل =========
local MusicTab = Window:CreateTab("المشغل الموسيقي", "rbxassetid://7733955511")

local MusicList = {