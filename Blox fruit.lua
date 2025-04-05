-- سكربت Blox Fruits المتكامل
-- الإصدار 1.5
-- تم التعديل والتحسين لضمان العمل بكفاءة

if not game:IsLoaded() then 
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game)
        wait(0.1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
    end)
    game.Loaded:Wait() 
end

-- فحص اللعبة مع رسالة تنبيه
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

-- تحميل المكتبة مع معالجة الأخطاء
local Rayfield, Library
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
end)

if not success then
    warn("فشل تحميل المكتبة: " .. err)
    return
end

-- إنشاء الواجهة الرئيسية
local Window = Rayfield:CreateWindow({
    Name = "Blox Fruits Pro - الإصدار العربي",
    LoadingTitle = "جاري التهيئة...",
    LoadingSubtitle = "النسخة 1.5 - مع نظام الموسيقى المتطور",
    ConfigurationSaving = { 
        Enabled = true,
        FolderName = "BloxFruitsConfig",
        FileName = "DeltaConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    }
})

-- تبويب الزراعة الذكية
local FarmTab = Window:CreateTab("الزراعة التلقائية", "rbxassetid://4483345998")

local AutoFarmToggle = FarmTab:CreateToggle({
    Name = "تفعيل الزراعة التلقائية",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        if Value then
            spawn(function()
                while getgenv().AutoFarmEnabled do
                    pcall(function()
                        -- البحث عن أقرب عدو
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

                        -- الهجوم إذا وجد عدو
                        if closestEnemy and minDistance < 50 then
                            -- محاكاة حركة بشرية
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = closestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                            
                            -- هجوم عشوائي
                            local attacks = {"Z", "X", "C", "V"}
                            local randomAttack = attacks[math.random(1, #attacks)]
                            keypress(Enum.KeyCode[randomAttack])
                            task.wait(0.1)
                            keyrelease(Enum.KeyCode[randomAttack])
                            
                            -- استراحة عشوائية لمحاكاة اللاعب البشري
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

-- تبويب التنقل بين الجزر
local TeleportTab = Window:CreateTab("نظام التنقل", "rbxassetid://7733918325")

local IslandLocations = {
    ["جزيرة الغابة"] = CFrame.new(-1600, 37, 150),
    ["القرية القرصنة"] = CFrame.new(-1181, 4, 3805),
    ["الصحراء"] = CFrame.new(944, 6, 4193),
    ["جزيرة الثلج"] = CFrame.new(1348, 8, -1321),
    ["مارينفورد"] = CFrame.new(-4485, 20, 1950)
}

local IslandDropdown = TeleportTab:CreateDropdown({
    Name = "اختر وجهتك",
    Options = table.keys(IslandLocations),
    CurrentOption = "جزيرة الغابة",
    Flag = "IslandSelection",
    Callback = function(Option)
        local targetCFrame = IslandLocations[Option]
        if targetCFrame then
            pcall(function()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
            end)
        end
    end
})

-- نظام Fruit Rain المتكامل
local FruitTab = Window:CreateTab("نظام Fruit Rain", "rbxassetid://7733960981")

local AllFruits = {
    "Bomb", "Spike", "Chop", "Spring", "Smoke", "Flame", 
    "Falcon", "Ice", "Sand", "Dark", "Diamond", "Light",
    "Rubber", "Barrier", "Ghost", "Magma", "Quake", 
    "Buddha", "Love", "Spider", "Sound", "Phoenix", 
    "Portal", "Rumble", "Pain", "Blizzard", "Gravity",
    "Mammoth", "Dough", "Shadow", "Venom", "Control",
    "Spirit", "Dragon", "Leopard", "Kitsune"
}

local FruitRainToggle = FruitTab:CreateToggle({
    Name = "تفعيل Fruit Rain الشامل",
    CurrentValue = false,
    Flag = "FruitRainToggle",
    Callback = function(Value)
        if Value then
            spawn(function()
                while getgenv().FruitRainEnabled do
                    pcall(function()
                        -- إسقاط فواكه عشوائية
                        local randomFruit = AllFruits[math.random(1, #AllFruits)]
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy", randomFruit)
                        
                        -- جذب الفواكه نحو اللاعب
                        for _, item in pairs(workspace:GetChildren()) do
                            if item.Name == "Fruit" and item:FindFirstChild("Handle") then
                                -- تحديد موقع عشوائي حول اللاعب
                                local randomOffset = Vector3.new(
                                    math.random(-8, 8),
                                    math.random(0, 5),
                                    math.random(-8, 8)
                                )
                                
                                item.Handle.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + randomOffset
                                
                                -- تأثير خاص للفواكه الأسطورية
                                if table.find({"Dragon", "Leopard", "Kitsune"}, item.Fruit.Value) then
                                    item.Handle.Velocity = Vector3.new(0, -15, 0)
                                end
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

FruitTab:CreateLabel("ملاحظة: تحتاج إلى 2,500$ لكل فاكهة")

-- =============================================
-- نظام الموسيقى المتطور (الإضافة الجديدة)
-- =============================================
local MusicTab = Window:CreateTab("المشغل الموسيقي", "rbxassetid://7733955511")

-- قائمة الأغاني مع ID الصحيح
local MusicList = {
    {"Montagem", "rbxassetid://9111547371"},
    {"Passo Bem Solto", "rbxassetid://13493488921"}, 
    {"NuNca Muda (Slowed)", "rbxassetid://12675503206"},
    {"Funk de Beleza (Slowed)", "rbxassetid://13005548539"},
    {"Montagem Lost Media (Ultra Slowed)", "rbxassetid://15437396195"}
}

-- متغيرات النظام
local CurrentSound
local OriginalVolume = game:GetService("SoundService").Volume

-- وظيفة إيقاف كل الأصوات
local function StopAllSounds()
    if CurrentSound then
        CurrentSound:Stop()
        CurrentSound:Destroy()
        CurrentSound = nil
    end
    game:GetService("SoundService").Volume = OriginalVolume
end

-- إنشاء عناصر واجهة لكل أغنية
for i, music in ipairs(MusicList) do
    local MusicSection = MusicTab:CreateSection(music[1])
    
    MusicSection:CreateButton({
        Name = "▶ تشغيل "..music[1],
        Callback = function()
            StopAllSounds()
            
            -- تخفيض صوت اللعبة
            game:GetService("SoundService").Volume = 0.2
            
            -- تشغيل الأغنية المحددة
            CurrentSound = Instance.new("Sound")
            CurrentSound.Name = "DeltaMusicPlayer"
            CurrentSound.SoundId = music[2]
            CurrentSound.Looped = true
            CurrentSound.Volume = 0.8
            CurrentSound.Parent = game:GetService("SoundService")
            CurrentSound:Play()
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "تم التشغيل",
                Text = "جاري تشغيل: "..music[1],
                Duration = 3,
                Icon = "rbxassetid://7733955511"
            })
        end
    })
    
    MusicSection:CreateButton({
        Name = "⏹ إيقاف "..music[1],
        Callback = function()
            if CurrentSound and CurrentSound.SoundId == music[2] then
                StopAllSounds()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "تم الإيقاف",
                    Text = "تم إيقاف: "..music[1],
                    Duration = 3
                })
            end
        end
    })
end

-- قسم التحكم العام
MusicTab:CreateSection("التحكم العام")

MusicTab:CreateButton({
    Name = "⏹ إيقاف كل الأغاني",
    Callback = function()
        StopAllSounds()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "تم الإيقاف",
            Text = "تم إيقاف جميع الأغاني",
            Duration = 3
        })
    end
})

MusicTab:CreateSlider({
    Name = "🔊 مستوى صوت الموسيقى",
    Range = {0, 100},
    Increment = 5,
    Suffix = "%",
    CurrentValue = 80,
    Callback = function(Value)
        if CurrentSound then
            CurrentSound.Volume = Value / 100
        end
    end
})

-- استعادة صوت اللعبة عند إغلاق السكربت
game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
    StopAllSounds()
end)

-- =============================================
-- نهاية نظام الموسيقى المتطور
-- =============================================

-- تبويب الإعدادات
local SettingsTab = Window:CreateTab("الإعدادات", "rbxassetid://7734053491")

SettingsTab:CreateKeybind({
    Name = "إظهار/إخفاء الواجهة",
    CurrentKeybind = "RightShift",
    HoldToInteract = false,
    Flag = "UIKeybind",
    Callback = function(Keybind)
        Rayfield:ToggleUI()
    end
})

SettingsTab:CreateButton({
    Name = "حفظ الإعدادات",
    Callback = function()
        Rayfield:SaveConfiguration()
    end
})

-- تحميل الإعدادات
Rayfield:LoadConfiguration()

-- رسالة بدء التشغيل
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "تم التحميل بنجاح",
    Text = "مرحباً بك في سكربت Blox Fruits Pro v1.5!",
    Duration = 5,
    Button1 = "تم",
    Icon = "rbxassetid://7733960981"
})