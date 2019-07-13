from PIL import Image

image = Image.open('palette.png').convert('RGBA')
pixels = image.load()

data = ''

for i in range(0, image.size[0]):
    data += "\\x%02x\\x%02x\\x%02x\\x%02x"%(pixels[i, 0][0],
                                            pixels[i, 0][1],
                                            pixels[i, 0][2],
                                            pixels[i, 0][3])

print("write(32, '%s')"%data)
