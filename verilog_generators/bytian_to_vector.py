
from math import sin, cos, pi

# prints out verilog mux
# this is a very big mux

num_degrees = 256
vector_length_meters = 50

def int_to_verilog(num, longer):
    start = "15'd" if longer else "14'd"

    if num >= 0:
        return start + str(num)
    else:
        return "-" + start + str(int(abs(num)))

# Converts a an angle into a vector of a specific length
if __name__ == "__main__":
    for angle in range(num_degrees):
        theta = angle * 2 * pi / num_degrees
        x, y = sin(theta), cos(theta)
        x = int(x * vector_length_meters)
        y = int(y * vector_length_meters)

        print("8'd" + str(angle) + ":")
        print("begin")
        print("    x[14:0] = " + int_to_verilog(x, True) + ";")
        print("    y[13:0] = " + int_to_verilog(y, False) + ";")
        print("end")
    
    # we need to include the default case
    theta = 0
    x, y = sin(theta), cos(theta)
    x = int(x * vector_length_meters)
    y = int(y * vector_length_meters)

    print("default:")
    print("begin")
    print("    x[14:0] = " + int_to_verilog(x, True) + ";")
    print("    y[13:0] = " + int_to_verilog(y, False) + ";")
    print("end")
