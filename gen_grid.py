# Usage: python3 gen_grid.py
# Output goes to STDOUT



print('module grid(clock, reset, x, y, write, in, out);')
print('    // Global clock and reset')
print('    input clock;')
print('    input reset;')
print('')
print('    // Coordinates for the grid, write enable (read if off), grid value')
print('    input [5:0] x;')
print('    input [4:0] y;')
print('    input write;')
print('    input [2:0] in;')
print('')
print('    // 3-bit output of what\'s contained in the grid address at xy')
print('    output [2:0] out;')
print('    reg [2:0] out;')
print('')


print('    // 1200 3-bit Registers to store 40x30 grid squares of data')
for x in range(40):
    for y in range(30):
        print('    reg [2:0] x{0}y{1};'.format(x, y))
print('')



print('    // Assign 3-bit input to addresses when write enable on')
print('    always @(posedge clock) begin')
print('        if (write == 1) begin')
print('            case (x)')
for x in range(40):
    print('                6\'d{0}: begin'.format(x))
    print('                    case (y)')
    for y in range(30):
        print('                        5\'d{0}: x{1}y{0} = in;'.format(y, x))
    print('                        default: ;')
    print('                    endcase')
    print('                end')
print('                default: ;')
print('            endcase')
print('        end // if ')

print('')
print('        // Reading address values, make sure to read everytime')
print('        case (x)')
for x in range(40):
    print('            6\'d{0}: begin'.format(x))
    print('                case (y)')
    for y in range(30):
        print('                    5\'d{0}: out = x{1}y{0};'.format(y, x))
    print('                    default: out = 3\'d0;')
    print('                endcase')
    print('            end')
print('            default: out = 3\'d0;')
print('        endcase')
print('    end // always')
print('endmodule')
