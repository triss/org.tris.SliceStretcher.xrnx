--[[============================================================================
Slice Stretcher
============================================================================]]--

_AUTO_RELOAD_DEBUG = true

--------------------------------------------------------------------------------
-- Main functions
--------------------------------------------------------------------------------

-- stretch every slice in an instrument relative to the stretching applied to 
-- the source sample
local function stretch_slices(i, beat_sync_mode)
  -- assumes the source is sample[1] in the instrument
  local source_length = i:sample(1).sample_buffer.number_of_frames
  local source_beats = i:sample(1).beat_sync_lines

  -- assumes every sample in the instrument is either source or slice
  -- should I check is_slice_alias?
  for _,s in pairs(i.samples) do
    local length_ratio = s.sample_buffer.number_of_frames / source_length

    -- assume rounding up of beat length to eliminate gaps
    s.beat_sync_lines = math.ceil(length_ratio * source_beats)
    s.beat_sync_mode = beat_sync_mode
    s.beat_sync_enabled = true
  end
end

local function double_length(i)
  for _,s in pairs(i.samples) do
    s.beat_sync_lines = s.beat_sync_lines * 2
  end
end

local function halve_length(i)
  for _,s in pairs(i.samples) do
    s.beat_sync_lines = math.ceil(s.beat_sync_lines / 2)
  end
end

local function set_beat_sync(i, b)
  for _, s in pairs(i.samples) do
    s.beat_sync_enabled = b
  end
end

local function set_mute_group(i, g)
  for _, s in pairs(i.samples) do
    s.mute_group = g
  end
end

local function set_nna(i, a)
  for _, s in pairs(i.samples) do
    s.new_note_action = a
  end
end

local function set_oneshot(i, b)
  for _, s in pairs(i.samples) do
    s.oneshot = b
  end
end

local function casiino_stretch(i)
  stretch_slices(i, renoise.Sample.BEAT_SYNC_TEXTURE)
  set_oneshot(i, true)
  set_mute_group(i, 1)
  set_nna(i, renoise.Sample.NEW_NOTE_ACTION_NOTE_CUT)
end

--------------------------------------------------------------------------------
-- UI stuff
--------------------------------------------------------------------------------

local function add_menu_and_keybind(t)
  renoise.tool():add_menu_entry { 
    name = "Sample Editor:Stretch Slices:" .. t.name, 
    invoke = t.invoke 
  }
  renoise.tool():add_keybinding { 
    name = "Global:Stretch Slices:" .. t.name, 
    invoke = t.invoke 
  }
end

add_menu_and_keybind {
  name = "Casiino Stretch",
  invoke = function() casiino_stretch( renoise.song().selected_instrument) end
}

add_menu_and_keybind {
  name = "With Texture Beatsync",
  invoke = function() 
    stretch_slices(
      renoise.song().selected_instrument, 
      renoise.Sample.BEAT_SYNC_TEXTURE
    )
  end
}

add_menu_and_keybind {
  name = "With Repitch Beatsync",
  invoke = function() 
    stretch_slices(
      renoise.song().selected_instrument, 
      renoise.Sample.BEAT_SYNC_REPITCH
    )
  end
}

add_menu_and_keybind {
  name = "With Percussion Beatsync",
  invoke = function() 
    stretch_slices(
      renoise.song().selected_instrument, 
      renoise.Sample.BEAT_SYNC_PERCUSSION
    )
  end
}

add_menu_and_keybind {
  name = "Double length",
  invoke = function() double_length(renoise.song().selected_instrument) end
}

add_menu_and_keybind {
  name = "Halve length",
  invoke = function() halve_length(renoise.song().selected_instrument) end
}

add_menu_and_keybind {
  name = "Enable Beat Sync",
  invoke = function() set_beat_sync(renoise.song().selected_instrument, true) end
}

add_menu_and_keybind {
  name = "Disable Beat Sync",
  invoke = function() set_beat_sync(renoise.song().selected_instrument, false) end
}

add_menu_and_keybind {
  name = "Enable One-Shot",
  invoke = function() set_oneshot(renoise.song().selected_instrument, true) end
}

add_menu_and_keybind {
  name = "Disable One-Shot",
  invoke = function() set_oneshot(renoise.song().selected_instrument, false) end
}

add_menu_and_keybind {
  name = "Set NNA Cut",
  invoke = function() 
    set_nna(renoise.song().selected_instrument, renoise.Sample.NEW_NOTE_ACTION_NOTE_CUT)
  end
}

add_menu_and_keybind {
  name = "Set NNA Note Off",
  invoke = function() 
    set_nna(renoise.song().selected_instrument, renoise.Sample.NEW_NOTE_ACTION_NOTE_OFF)
  end
}

add_menu_and_keybind {
  name = "Set NNA Sustain",
  invoke = function() 
    set_nna(renoise.song().selected_instrument, renoise.Sample.NEW_NOTE_ACTION_SUSTAIN)
  end
}

add_menu_and_keybind {
  name = "Set Mute Group 1",
  invoke = function() 
    set_mute_group(renoise.song().selected_instrument, 1)
  end
}

add_menu_and_keybind {
  name = "Set Mute Group None",
  invoke = function() 
    set_mute_group(renoise.song().selected_instrument, 0)
  end
}
