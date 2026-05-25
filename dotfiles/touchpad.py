import subprocess
import json
import sys

def get_touchpad_info():
    try:
        output = subprocess.check_output(["hyprctl", "devices", "-j"])
        devices = json.loads(output)
        mice = devices.get("mice", [])
        for mouse in mice:
            if "touchpad" in mouse["name"].lower():
                return mouse
    except Exception:
        return None
    return None

def toggle_touchpad(name, current_state):
    new_state = "true" if not current_state else "false"
    subprocess.run(["hyprctl", "keyword", f"device[{name}]:enabled", new_state])
    
    # Notify user
    status = "Enabled" if new_state == "true" else "Disabled"
    icon = "󰟖" if new_state == "true" else "󰟗"
    subprocess.run(["dunstify", "-a", "Touchpad", "-i", "input-touchpad", f"Touchpad {status}", icon])

def main():
    touchpad = get_touchpad_info()
    
    if not touchpad:
        print(json.dumps({"text": "󰟖", "tooltip": "No touchpad found", "class": "error"}))
        return

    name = touchpad["name"]
    enabled = touchpad["enabled"]

    if len(sys.argv) > 1 and sys.argv[1] == "toggle":
        toggle_touchpad(name, enabled)
        # Re-fetch state for updated display
        touchpad = get_touchpad_info()
        enabled = touchpad["enabled"]

    icon = "󰟖" if enabled else "󰟗"
    text = icon
    tooltip = f"Touchpad: {'Enabled' if enabled else 'Disabled'}\nDevice: {name}"
    css_class = "enabled" if enabled else "disabled"

    print(json.dumps({"text": text, "tooltip": tooltip, "class": css_class}))

if __name__ == "__main__":
    main()
