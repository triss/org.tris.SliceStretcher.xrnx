--[[============================================================================
Instrument Randomizer
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


--------------------------------------------------------------------------------
-- UI stuff
--------------------------------------------------------------------------------

renoise.tool():add_menu_entry {
  name = "Sample Editor:Stretch Slices:With Texture Beatsync",
  invoke = function() 
    stretch_slices(
      renoise.song().selected_instrument, 
      renoise.Sample.BEAT_SYNC_TEXTURE
    )
  end
}

renoise.tool():add_keybinding {
  name = "Global:Stretch Slices:With Texture Beatsync",
  invoke = function() 
    stretch_slices(
      renoise.song().selected_instrument, 
      renoise.Sample.BEAT_SYNC_TEXTURE
    )
  end
}

renoise.tool():add_menu_entry {
  name = "Sample Editor:Stretch Slices:With Repitch Beatsync",
  invoke = function() 
    stretch_slices(
      renoise.song().selected_instrument, 
      renoise.Sample.BEAT_SYNC_REPITCH
    )
  end
}

renoise.tool():add_keybinding {
  name = "Global:Stretch Slices:With Repitch Beatsync",
  invoke = function() 
    stretch_slices(
      renoise.song().selected_instrument, 
      renoise.Sample.BEAT_SYNC_REPITCH
    )
  end
}
renoise.tool():add_menu_entry {
  name = "Sample Editor:Stretch Slices:With Percussion Beatsync",
  invoke = function() 
    stretch_slices(
      renoise.song().selected_instrument, 
      renoise.Sample.BEAT_SYNC_PERCUSSION
    )
  end
}

renoise.tool():add_keybinding {
  name = "Global:Stretch Slices:With Percussion Beatsync",
  invoke = function() 
    stretch_slices(
      renoise.song().selected_instrument, 
      renoise.Sample.BEAT_SYNC_PERCUSSION
    )
  end
}

renoise.tool():add_menu_entry {
  name = "Sample Editor:Stretch Slices:Double length",
  invoke = function() double_length(renoise.song().selected_instrument) end
}

renoise.tool():add_menu_entry {
  name = "Sample Editor:Stretch Slices:Halve length",
  invoke = function() halve_length(renoise.song().selected_instrument) end
}

renoise.tool():add_keybinding {
  name = "Global:Stretch Slices:Double length",
  invoke = function() double_length(renoise.song().selected_instrument) end
}

renoise.tool():add_keybinding {
  name = "Global:Stretch Slices:Halve length",
  invoke = function() halve_length(renoise.song().selected_instrument) end
}
