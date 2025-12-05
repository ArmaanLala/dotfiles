function rdr --description "Navigate to a specific Radar problem folder by radar number"
    # Colors
    set -l green (set_color green)
    set -l blue (set_color blue)
    set -l yellow (set_color yellow)
    set -l red (set_color red)
    set -l cyan (set_color cyan)
    set -l normal (set_color normal)

    # Check for help flag
    if test "$argv[1]" = "-h" -o "$argv[1]" = "--help"
        echo "Usage: rdr <radar_number>"
        echo ""
        echo "Navigate to a specific Radar problem folder"
        echo ""
        echo "Arguments:"
        echo "  <radar_number>  The radar number (e.g., 123456789)"
        echo ""
        echo "Example:"
        echo "  rdr 123456789"
        return 0
    end

    # Check if radar number is provided
    if test (count $argv) -eq 0
        echo "Usage: rdr <radar_number>"
        return 1
    end

    set -l radar_number $argv[1]
    set -l radar_base_path "$HOME/Library/Application Support/Radar/Downloads/Problem"
    set -l radar_path "$radar_base_path/$radar_number"

    # Check if radar folder exists
    if not test -d "$radar_path"
        echo $red"[ERROR]"$normal" Failed to find radar "$radar_number$normal
        return 1
    end

    # Navigate to the radar folder
    cd "$radar_path"
    if test $status -eq 0
        echo $green"[SUCCESS]"$normal" Found Radar "$cyan$radar_number$normal
    else
        echo $red"[ERROR]"$normal" Failed to navigate to radar "$radar_number$normal
        return 1
    end
end
