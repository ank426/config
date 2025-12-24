-- Table to store delays for each subtitle track ID
local track_delays = {}
local last_sid = mp.get_property_number("sid", 0)

-- Function to save and switch delays
local function on_sid_change(name, current_sid)
    -- If SID is nil or 0 (subs off), just return
    if not current_sid or current_sid == 0 then return end

    -- Save current delay to the OLD track before switching
    if last_sid > 0 then
        track_delays[last_sid] = mp.get_property_number("sub-delay", 0)
    end

    -- Load the saved delay for the NEW track (default to 0 if never set)
    local new_delay = track_delays[current_sid] or 0
    mp.set_property_number("sub-delay", new_delay)

    -- Update last_sid reference
    last_sid = current_sid
    -- mp.osd_message("Track " .. current_sid .. " delay: " .. new_delay .. "s")
end

-- Monitor when the user switches subtitle tracks
mp.observe_property("sid", "number", on_sid_change)

-- Function to handle manual delay adjustments (z/x keys)
local function on_delay_change()
    local current_sid = mp.get_property_number("sid", 0)
    if current_sid > 0 then
        track_delays[current_sid] = mp.get_property_number("sub-delay", 0)
    end
end

-- Monitor when the delay itself is changed
mp.observe_property("sub-delay", "number", on_delay_change)
