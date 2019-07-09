
from math import sin, cos, pi

# prints out verilog mux
# this is a very big mux

num_degrees = 256
vector_length_meters = 50


# Converts a an angle into a vector of a specific length
if __name__ == "__main__":
    for angle in range(num_degrees):
        theta = angle * 2 * pi / num_degrees
        x, y = sin(theta), cos(theta)
        x = int(x * vector_length_meters)
        y = int(y * vector_length_meters)

        print("8'd" + str(angle) + ":")
        print("begin")
        print("    x =", str(x))
        print("    y =", str(y))
        print("end")
