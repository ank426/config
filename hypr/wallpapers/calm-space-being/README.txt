magick original.png -threshold 50% binary.png

magick original.png -gamma x gamma/x.png (for some reason it isn't diffing with mine. possibly non-deterministic or update. saved are the old ones)
magick binary.png -fill "#x" -opaque white fill/x.png

old was gamma/0.8.png
