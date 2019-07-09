# Usage: python3 gen_level.py LEVEL_FILE VERILOG_MODULE
# Output goes to STDOUT

import sys

values = []

with open(sys.argv[1], 'r') as file:
    for line in file:
        values.append(list(map(int, line[:-1])))

print('module {0}(x, y, value);'.format(sys.argv[2]))
print('    input [5:0] x;')
print('    input [4:0] y;')
print('    output [2:0] value;')
print('')
print('    reg [2:0] value;')
print('    always @(*)')
print('    case (x)')
for x in range(40):
    print('        6\'d{0}: begin'.format(x))
    print('            case (y)')
    for y in range(30):
        print('                5\'d{0}: value = 3\'d{1};'.format(y, values[y][x]))
    print('                default: value = 3\'d0;')
    print('            endcase')
    print('        end'.format(x))
print('        default: value = 3\'d0;')
print('    endcase')
print('endmodule')
