local mod_path = "" .. SMODS.current_mod.path
Entropy.path = mod_path

local i = {
    "lib/colours",
    "lib/utils",
    "lib/config",
    "lib/hooks",
    "lib/loader",
    "lib/ui",
    "lib/fixes",

    "items/misc/atlases",
    "items/misc/rarities",
    "items/misc/spectrals",
    "items/misc/content_sets",
    "items/misc/consumable_types",
    "items/misc/enhancements",
    "items/misc/seals",
    "items/misc/editions",
    "items/misc/sounds",
    "items/misc/tags",
    "items/misc/boosters",
    "items/misc/vouchers",
    "items/misc/decks",
    "items/misc/blinds",
    "items/misc/stakes",
    "items/misc/challenges",
    "items/misc/achievements",
    "items/misc/other",

    "items/jokers/cursed_jokers",
    "items/jokers/misc_jokers",
    "items/jokers/epic_jokers",
    "items/jokers/exotic_jokers",
    "items/jokers/rlegendary_jokers",
    "items/jokers/entropic_jokers",
    "items/jokers/zenith_jokers",

    "items/inversions/reverse_tarots",
    "items/inversions/reverse_spectrals",
    "items/inversions/reverse_planets",
    "items/inversions/reverse_codes",

    "items/misc/blind_tokens",
    "items/inversions/define",

    "items/altpath/blinds",

    "compat/partners",
    "compat/finity"
}
local items = {}
for _, v in pairs(i) do
    local f, err = SMODS.load_file(v..".lua")
    if f then 
        local results = f() 
        if results then
            if results.init then results.init(results) end
            if results.items then
                for i, result in pairs(results.items) do
                    if not items[result.object_type] then items[result.object_type] = {} end
                    result.cry_order = result.order
                    items[result.object_type][#items[result.object_type]+1]=result
                end
            end
        end
    else error("error in file "..v..": "..err) end
end
for i, category in pairs(items) do
    table.sort(category, function(a, b) return a.order < b.order end)
    for i2, item in pairs(category) do
        if not SMODS[item.object_type] then Entropy.fucker = item.object_type
        else SMODS[item.object_type](item) end
        item = nil
    end
    category = nil
    for i, v in pairs(SMODS[i].obj_table) do
        if v.inversion then 
            Entropy.FlipsidePureInversions[v.inversion]=i 
            Entropy.FlipsideInversions[v.inversion]=i 
            Entropy.FlipsideInversions[i]=v.inversion
        end
        if v.altpath then
            Entropy.AltBlinds[#Entropy.AltBlinds+1] = v
        end
    end
end
items = nil
SMODS.current_mod.optional_features = {
	retrigger_joker = true,
}

Cryptid.mod_whitelist["Entropy"] = true
if not Cryptid.mod_gameset_whitelist then Cryptid.mod_gameset_whitelist = {} end
Cryptid.mod_gameset_whitelist["entr"] = true
Cryptid.mod_gameset_whitelist["Entropy"] = true


Cryptid.pointerblistifytype("rarity", "entr_entropic")
Cryptid.pointerblistifytype("rarity", "entr_zenith")
Cryptid.pointerblistify("c_entr_define")
for i, v in pairs(G.P_BLINDS) do
    Cryptid.pointerblistify(i)
end

for i, v in pairs(SMODS.Blind.obj_table) do
    Cryptid.pointerblistify(i)
end