# Let's convert the hex color to HSL, increase its lightness, and then convert it back to hex.

from colorsys import hls_to_rgb, rgb_to_hls


def hex_to_rgb(hex_code):
    """Convert hex color to RGB tuple."""
    hex_code = hex_code.lstrip("#")
    return tuple(int(hex_code[i : i + 2], 16) for i in (0, 2, 4))


def rgb_to_hex(rgb_tuple):
    """Convert RGB tuple to hex color."""
    return "#{:02x}{:02x}{:02x}".format(*[int(c) for c in rgb_tuple])


def increase_lightness(hex_code, factor=0.2):
    """Increase lightness of a given hex color."""
    # Convert hex to RGB
    rgb = hex_to_rgb(hex_code)
    # Normalize RGB values to [0, 1] range for HLS conversion
    rgb_normalized = tuple(c / 255.0 for c in rgb)

    # Convert RGB to HLS
    h, l, s = rgb_to_hls(*rgb_normalized)

    # Increase lightness
    l = min(1, l + factor)

    # Convert back to RGB from HLS
    new_rgb_normalized = hls_to_rgb(h, l, s)

    # Denormalize RGB values back to [0, 255] range
    new_rgb = tuple(int(c * 255) for c in new_rgb_normalized)

    # Convert RGB back to hex
    return rgb_to_hex(new_rgb)


# # Given hex color
# hex_color = "#384148"
#
# # Increase brightness by 20%
# brighter_hex_color = increase_lightness(hex_color, factor=0.3)
# print(brighter_hex_color)

hex_colors = [
    "#384148",
    "#8cc1ff",
    "#90daff",
    "#94f7c5",
    "#e2a6ff",
    "#fc7b81",
    "#fafdff",
    "#ffeba6",
    "#1c252c",
    "#70a5eb",
    "#74bee9",
    "#78dba9",
    "#c68aee",
    "#e05f65",
    "#dee1e6",
    "#f1cf8a",
]
for hex_color in hex_colors:
    print(increase_lightness(hex_color, factor=0.1))
