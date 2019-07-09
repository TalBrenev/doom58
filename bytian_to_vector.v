module bytian_to_vector(bytian, x, y);
    input [7:0] bytian;

    reg [13:0] x;
    reg [12:0] y;

    output [13:0] x;
    output [12:0] y;

    // generated in the bytian_to_vector.py file
    
    always @(*) begin
        case bytian
        8'd0:
        begin
            x = 8'd0;
            y = 8'd50;
        end
        8'd1:
        begin
            x = 8'd1;
            y = 8'd49;
        end
        8'd2:
        begin
            x = 8'd2;
            y = 8'd49;
        end
        8'd3:
        begin
            x = 8'd3;
            y = 8'd49;
        end
        8'd4:
        begin
            x = 8'd4;
            y = 8'd49;
        end
        8'd5:
        begin
            x = 8'd6;
            y = 8'd49;
        end
        8'd6:
        begin
            x = 8'd7;
            y = 8'd49;
        end
        8'd7:
        begin
            x = 8'd8;
            y = 8'd49;
        end
        8'd8:
        begin
            x = 8'd9;
            y = 8'd49;
        end
        8'd9:
        begin
            x = 8'd10;
            y = 8'd48;
        end
        8'd10:
        begin
            x = 8'd12;
            y = 8'd48;
        end
        8'd11:
        begin
            x = 8'd13;
            y = 8'd48;
        end
        8'd12:
        begin
            x = 8'd14;
            y = 8'd47;
        end
        8'd13:
        begin
            x = 8'd15;
            y = 8'd47;
        end
        8'd14:
        begin
            x = 8'd16;
            y = 8'd47;
        end
        8'd15:
        begin
            x = 8'd17;
            y = 8'd46;
        end
        8'd16:
        begin
            x = 8'd19;
            y = 8'd46;
        end
        8'd17:
        begin
            x = 8'd20;
            y = 8'd45;
        end
        8'd18:
        begin
            x = 8'd21;
            y = 8'd45;
        end
        8'd19:
        begin
            x = 8'd22;
            y = 8'd44;
        end
        8'd20:
        begin
            x = 8'd23;
            y = 8'd44;
        end
        8'd21:
        begin
            x = 8'd24;
            y = 8'd43;
        end
        8'd22:
        begin
            x = 8'd25;
            y = 8'd42;
        end
        8'd23:
        begin
            x = 8'd26;
            y = 8'd42;
        end
        8'd24:
        begin
            x = 8'd27;
            y = 8'd41;
        end
        8'd25:
        begin
            x = 8'd28;
            y = 8'd40;
        end
        8'd26:
        begin
            x = 8'd29;
            y = 8'd40;
        end
        8'd27:
        begin
            x = 8'd30;
            y = 8'd39;
        end
        8'd28:
        begin
            x = 8'd31;
            y = 8'd38;
        end
        8'd29:
        begin
            x = 8'd32;
            y = 8'd37;
        end
        8'd30:
        begin
            x = 8'd33;
            y = 8'd37;
        end
        8'd31:
        begin
            x = 8'd34;
            y = 8'd36;
        end
        8'd32:
        begin
            x = 8'd35;
            y = 8'd35;
        end
        8'd33:
        begin
            x = 8'd36;
            y = 8'd34;
        end
        8'd34:
        begin
            x = 8'd37;
            y = 8'd33;
        end
        8'd35:
        begin
            x = 8'd37;
            y = 8'd32;
        end
        8'd36:
        begin
            x = 8'd38;
            y = 8'd31;
        end
        8'd37:
        begin
            x = 8'd39;
            y = 8'd30;
        end
        8'd38:
        begin
            x = 8'd40;
            y = 8'd29;
        end
        8'd39:
        begin
            x = 8'd40;
            y = 8'd28;
        end
        8'd40:
        begin
            x = 8'd41;
            y = 8'd27;
        end
        8'd41:
        begin
            x = 8'd42;
            y = 8'd26;
        end
        8'd42:
        begin
            x = 8'd42;
            y = 8'd25;
        end
        8'd43:
        begin
            x = 8'd43;
            y = 8'd24;
        end
        8'd44:
        begin
            x = 8'd44;
            y = 8'd23;
        end
        8'd45:
        begin
            x = 8'd44;
            y = 8'd22;
        end
        8'd46:
        begin
            x = 8'd45;
            y = 8'd21;
        end
        8'd47:
        begin
            x = 8'd45;
            y = 8'd20;
        end
        8'd48:
        begin
            x = 8'd46;
            y = 8'd19;
        end
        8'd49:
        begin
            x = 8'd46;
            y = 8'd17;
        end
        8'd50:
        begin
            x = 8'd47;
            y = 8'd16;
        end
        8'd51:
        begin
            x = 8'd47;
            y = 8'd15;
        end
        8'd52:
        begin
            x = 8'd47;
            y = 8'd14;
        end
        8'd53:
        begin
            x = 8'd48;
            y = 8'd13;
        end
        8'd54:
        begin
            x = 8'd48;
            y = 8'd12;
        end
        8'd55:
        begin
            x = 8'd48;
            y = 8'd10;
        end
        8'd56:
        begin
            x = 8'd49;
            y = 8'd9;
        end
        8'd57:
        begin
            x = 8'd49;
            y = 8'd8;
        end
        8'd58:
        begin
            x = 8'd49;
            y = 8'd7;
        end
        8'd59:
        begin
            x = 8'd49;
            y = 8'd6;
        end
        8'd60:
        begin
            x = 8'd49;
            y = 8'd4;
        end
        8'd61:
        begin
            x = 8'd49;
            y = 8'd3;
        end
        8'd62:
        begin
            x = 8'd49;
            y = 8'd2;
        end
        8'd63:
        begin
            x = 8'd49;
            y = 8'd1;
        end
        8'd64:
        begin
            x = 8'd50;
            y = 8'd0;
        end
        8'd65:
        begin
            x = 8'd49;
            y = -8'd1;
        end
        8'd66:
        begin
            x = 8'd49;
            y = -8'd2;
        end
        8'd67:
        begin
            x = 8'd49;
            y = -8'd3;
        end
        8'd68:
        begin
            x = 8'd49;
            y = -8'd4;
        end
        8'd69:
        begin
            x = 8'd49;
            y = -8'd6;
        end
        8'd70:
        begin
            x = 8'd49;
            y = -8'd7;
        end
        8'd71:
        begin
            x = 8'd49;
            y = -8'd8;
        end
        8'd72:
        begin
            x = 8'd49;
            y = -8'd9;
        end
        8'd73:
        begin
            x = 8'd48;
            y = -8'd10;
        end
        8'd74:
        begin
            x = 8'd48;
            y = -8'd12;
        end
        8'd75:
        begin
            x = 8'd48;
            y = -8'd13;
        end
        8'd76:
        begin
            x = 8'd47;
            y = -8'd14;
        end
        8'd77:
        begin
            x = 8'd47;
            y = -8'd15;
        end
        8'd78:
        begin
            x = 8'd47;
            y = -8'd16;
        end
        8'd79:
        begin
            x = 8'd46;
            y = -8'd17;
        end
        8'd80:
        begin
            x = 8'd46;
            y = -8'd19;
        end
        8'd81:
        begin
            x = 8'd45;
            y = -8'd20;
        end
        8'd82:
        begin
            x = 8'd45;
            y = -8'd21;
        end
        8'd83:
        begin
            x = 8'd44;
            y = -8'd22;
        end
        8'd84:
        begin
            x = 8'd44;
            y = -8'd23;
        end
        8'd85:
        begin
            x = 8'd43;
            y = -8'd24;
        end
        8'd86:
        begin
            x = 8'd42;
            y = -8'd25;
        end
        8'd87:
        begin
            x = 8'd42;
            y = -8'd26;
        end
        8'd88:
        begin
            x = 8'd41;
            y = -8'd27;
        end
        8'd89:
        begin
            x = 8'd40;
            y = -8'd28;
        end
        8'd90:
        begin
            x = 8'd40;
            y = -8'd29;
        end
        8'd91:
        begin
            x = 8'd39;
            y = -8'd30;
        end
        8'd92:
        begin
            x = 8'd38;
            y = -8'd31;
        end
        8'd93:
        begin
            x = 8'd37;
            y = -8'd32;
        end
        8'd94:
        begin
            x = 8'd37;
            y = -8'd33;
        end
        8'd95:
        begin
            x = 8'd36;
            y = -8'd34;
        end
        8'd96:
        begin
            x = 8'd35;
            y = -8'd35;
        end
        8'd97:
        begin
            x = 8'd34;
            y = -8'd36;
        end
        8'd98:
        begin
            x = 8'd33;
            y = -8'd37;
        end
        8'd99:
        begin
            x = 8'd32;
            y = -8'd37;
        end
        8'd100:
        begin
            x = 8'd31;
            y = -8'd38;
        end
        8'd101:
        begin
            x = 8'd30;
            y = -8'd39;
        end
        8'd102:
        begin
            x = 8'd29;
            y = -8'd40;
        end
        8'd103:
        begin
            x = 8'd28;
            y = -8'd40;
        end
        8'd104:
        begin
            x = 8'd27;
            y = -8'd41;
        end
        8'd105:
        begin
            x = 8'd26;
            y = -8'd42;
        end
        8'd106:
        begin
            x = 8'd25;
            y = -8'd42;
        end
        8'd107:
        begin
            x = 8'd24;
            y = -8'd43;
        end
        8'd108:
        begin
            x = 8'd23;
            y = -8'd44;
        end
        8'd109:
        begin
            x = 8'd22;
            y = -8'd44;
        end
        8'd110:
        begin
            x = 8'd21;
            y = -8'd45;
        end
        8'd111:
        begin
            x = 8'd20;
            y = -8'd45;
        end
        8'd112:
        begin
            x = 8'd19;
            y = -8'd46;
        end
        8'd113:
        begin
            x = 8'd17;
            y = -8'd46;
        end
        8'd114:
        begin
            x = 8'd16;
            y = -8'd47;
        end
        8'd115:
        begin
            x = 8'd15;
            y = -8'd47;
        end
        8'd116:
        begin
            x = 8'd14;
            y = -8'd47;
        end
        8'd117:
        begin
            x = 8'd13;
            y = -8'd48;
        end
        8'd118:
        begin
            x = 8'd12;
            y = -8'd48;
        end
        8'd119:
        begin
            x = 8'd10;
            y = -8'd48;
        end
        8'd120:
        begin
            x = 8'd9;
            y = -8'd49;
        end
        8'd121:
        begin
            x = 8'd8;
            y = -8'd49;
        end
        8'd122:
        begin
            x = 8'd7;
            y = -8'd49;
        end
        8'd123:
        begin
            x = 8'd6;
            y = -8'd49;
        end
        8'd124:
        begin
            x = 8'd4;
            y = -8'd49;
        end
        8'd125:
        begin
            x = 8'd3;
            y = -8'd49;
        end
        8'd126:
        begin
            x = 8'd2;
            y = -8'd49;
        end
        8'd127:
        begin
            x = 8'd1;
            y = -8'd49;
        end
        8'd128:
        begin
            x = 8'd0;
            y = -8'd50;
        end
        8'd129:
        begin
            x = -8'd1;
            y = -8'd49;
        end
        8'd130:
        begin
            x = -8'd2;
            y = -8'd49;
        end
        8'd131:
        begin
            x = -8'd3;
            y = -8'd49;
        end
        8'd132:
        begin
            x = -8'd4;
            y = -8'd49;
        end
        8'd133:
        begin
            x = -8'd6;
            y = -8'd49;
        end
        8'd134:
        begin
            x = -8'd7;
            y = -8'd49;
        end
        8'd135:
        begin
            x = -8'd8;
            y = -8'd49;
        end
        8'd136:
        begin
            x = -8'd9;
            y = -8'd49;
        end
        8'd137:
        begin
            x = -8'd10;
            y = -8'd48;
        end
        8'd138:
        begin
            x = -8'd12;
            y = -8'd48;
        end
        8'd139:
        begin
            x = -8'd13;
            y = -8'd48;
        end
        8'd140:
        begin
            x = -8'd14;
            y = -8'd47;
        end
        8'd141:
        begin
            x = -8'd15;
            y = -8'd47;
        end
        8'd142:
        begin
            x = -8'd16;
            y = -8'd47;
        end
        8'd143:
        begin
            x = -8'd17;
            y = -8'd46;
        end
        8'd144:
        begin
            x = -8'd19;
            y = -8'd46;
        end
        8'd145:
        begin
            x = -8'd20;
            y = -8'd45;
        end
        8'd146:
        begin
            x = -8'd21;
            y = -8'd45;
        end
        8'd147:
        begin
            x = -8'd22;
            y = -8'd44;
        end
        8'd148:
        begin
            x = -8'd23;
            y = -8'd44;
        end
        8'd149:
        begin
            x = -8'd24;
            y = -8'd43;
        end
        8'd150:
        begin
            x = -8'd25;
            y = -8'd42;
        end
        8'd151:
        begin
            x = -8'd26;
            y = -8'd42;
        end
        8'd152:
        begin
            x = -8'd27;
            y = -8'd41;
        end
        8'd153:
        begin
            x = -8'd28;
            y = -8'd40;
        end
        8'd154:
        begin
            x = -8'd29;
            y = -8'd40;
        end
        8'd155:
        begin
            x = -8'd30;
            y = -8'd39;
        end
        8'd156:
        begin
            x = -8'd31;
            y = -8'd38;
        end
        8'd157:
        begin
            x = -8'd32;
            y = -8'd37;
        end
        8'd158:
        begin
            x = -8'd33;
            y = -8'd37;
        end
        8'd159:
        begin
            x = -8'd34;
            y = -8'd36;
        end
        8'd160:
        begin
            x = -8'd35;
            y = -8'd35;
        end
        8'd161:
        begin
            x = -8'd36;
            y = -8'd34;
        end
        8'd162:
        begin
            x = -8'd37;
            y = -8'd33;
        end
        8'd163:
        begin
            x = -8'd37;
            y = -8'd32;
        end
        8'd164:
        begin
            x = -8'd38;
            y = -8'd31;
        end
        8'd165:
        begin
            x = -8'd39;
            y = -8'd30;
        end
        8'd166:
        begin
            x = -8'd40;
            y = -8'd29;
        end
        8'd167:
        begin
            x = -8'd40;
            y = -8'd28;
        end
        8'd168:
        begin
            x = -8'd41;
            y = -8'd27;
        end
        8'd169:
        begin
            x = -8'd42;
            y = -8'd26;
        end
        8'd170:
        begin
            x = -8'd42;
            y = -8'd25;
        end
        8'd171:
        begin
            x = -8'd43;
            y = -8'd24;
        end
        8'd172:
        begin
            x = -8'd44;
            y = -8'd23;
        end
        8'd173:
        begin
            x = -8'd44;
            y = -8'd22;
        end
        8'd174:
        begin
            x = -8'd45;
            y = -8'd21;
        end
        8'd175:
        begin
            x = -8'd45;
            y = -8'd20;
        end
        8'd176:
        begin
            x = -8'd46;
            y = -8'd19;
        end
        8'd177:
        begin
            x = -8'd46;
            y = -8'd17;
        end
        8'd178:
        begin
            x = -8'd47;
            y = -8'd16;
        end
        8'd179:
        begin
            x = -8'd47;
            y = -8'd15;
        end
        8'd180:
        begin
            x = -8'd47;
            y = -8'd14;
        end
        8'd181:
        begin
            x = -8'd48;
            y = -8'd13;
        end
        8'd182:
        begin
            x = -8'd48;
            y = -8'd12;
        end
        8'd183:
        begin
            x = -8'd48;
            y = -8'd10;
        end
        8'd184:
        begin
            x = -8'd49;
            y = -8'd9;
        end
        8'd185:
        begin
            x = -8'd49;
            y = -8'd8;
        end
        8'd186:
        begin
            x = -8'd49;
            y = -8'd7;
        end
        8'd187:
        begin
            x = -8'd49;
            y = -8'd6;
        end
        8'd188:
        begin
            x = -8'd49;
            y = -8'd4;
        end
        8'd189:
        begin
            x = -8'd49;
            y = -8'd3;
        end
        8'd190:
        begin
            x = -8'd49;
            y = -8'd2;
        end
        8'd191:
        begin
            x = -8'd49;
            y = -8'd1;
        end
        8'd192:
        begin
            x = -8'd50;
            y = 8'd0;
        end
        8'd193:
        begin
            x = -8'd49;
            y = 8'd1;
        end
        8'd194:
        begin
            x = -8'd49;
            y = 8'd2;
        end
        8'd195:
        begin
            x = -8'd49;
            y = 8'd3;
        end
        8'd196:
        begin
            x = -8'd49;
            y = 8'd4;
        end
        8'd197:
        begin
            x = -8'd49;
            y = 8'd6;
        end
        8'd198:
        begin
            x = -8'd49;
            y = 8'd7;
        end
        8'd199:
        begin
            x = -8'd49;
            y = 8'd8;
        end
        8'd200:
        begin
            x = -8'd49;
            y = 8'd9;
        end
        8'd201:
        begin
            x = -8'd48;
            y = 8'd10;
        end
        8'd202:
        begin
            x = -8'd48;
            y = 8'd12;
        end
        8'd203:
        begin
            x = -8'd48;
            y = 8'd13;
        end
        8'd204:
        begin
            x = -8'd47;
            y = 8'd14;
        end
        8'd205:
        begin
            x = -8'd47;
            y = 8'd15;
        end
        8'd206:
        begin
            x = -8'd47;
            y = 8'd16;
        end
        8'd207:
        begin
            x = -8'd46;
            y = 8'd17;
        end
        8'd208:
        begin
            x = -8'd46;
            y = 8'd19;
        end
        8'd209:
        begin
            x = -8'd45;
            y = 8'd20;
        end
        8'd210:
        begin
            x = -8'd45;
            y = 8'd21;
        end
        8'd211:
        begin
            x = -8'd44;
            y = 8'd22;
        end
        8'd212:
        begin
            x = -8'd44;
            y = 8'd23;
        end
        8'd213:
        begin
            x = -8'd43;
            y = 8'd24;
        end
        8'd214:
        begin
            x = -8'd42;
            y = 8'd25;
        end
        8'd215:
        begin
            x = -8'd42;
            y = 8'd26;
        end
        8'd216:
        begin
            x = -8'd41;
            y = 8'd27;
        end
        8'd217:
        begin
            x = -8'd40;
            y = 8'd28;
        end
        8'd218:
        begin
            x = -8'd40;
            y = 8'd29;
        end
        8'd219:
        begin
            x = -8'd39;
            y = 8'd30;
        end
        8'd220:
        begin
            x = -8'd38;
            y = 8'd31;
        end
        8'd221:
        begin
            x = -8'd37;
            y = 8'd32;
        end
        8'd222:
        begin
            x = -8'd37;
            y = 8'd33;
        end
        8'd223:
        begin
            x = -8'd36;
            y = 8'd34;
        end
        8'd224:
        begin
            x = -8'd35;
            y = 8'd35;
        end
        8'd225:
        begin
            x = -8'd34;
            y = 8'd36;
        end
        8'd226:
        begin
            x = -8'd33;
            y = 8'd37;
        end
        8'd227:
        begin
            x = -8'd32;
            y = 8'd37;
        end
        8'd228:
        begin
            x = -8'd31;
            y = 8'd38;
        end
        8'd229:
        begin
            x = -8'd30;
            y = 8'd39;
        end
        8'd230:
        begin
            x = -8'd29;
            y = 8'd40;
        end
        8'd231:
        begin
            x = -8'd28;
            y = 8'd40;
        end
        8'd232:
        begin
            x = -8'd27;
            y = 8'd41;
        end
        8'd233:
        begin
            x = -8'd26;
            y = 8'd42;
        end
        8'd234:
        begin
            x = -8'd25;
            y = 8'd42;
        end
        8'd235:
        begin
            x = -8'd24;
            y = 8'd43;
        end
        8'd236:
        begin
            x = -8'd23;
            y = 8'd44;
        end
        8'd237:
        begin
            x = -8'd22;
            y = 8'd44;
        end
        8'd238:
        begin
            x = -8'd21;
            y = 8'd45;
        end
        8'd239:
        begin
            x = -8'd20;
            y = 8'd45;
        end
        8'd240:
        begin
            x = -8'd19;
            y = 8'd46;
        end
        8'd241:
        begin
            x = -8'd17;
            y = 8'd46;
        end
        8'd242:
        begin
            x = -8'd16;
            y = 8'd47;
        end
        8'd243:
        begin
            x = -8'd15;
            y = 8'd47;
        end
        8'd244:
        begin
            x = -8'd14;
            y = 8'd47;
        end
        8'd245:
        begin
            x = -8'd13;
            y = 8'd48;
        end
        8'd246:
        begin
            x = -8'd12;
            y = 8'd48;
        end
        8'd247:
        begin
            x = -8'd10;
            y = 8'd48;
        end
        8'd248:
        begin
            x = -8'd9;
            y = 8'd49;
        end
        8'd249:
        begin
            x = -8'd8;
            y = 8'd49;
        end
        8'd250:
        begin
            x = -8'd7;
            y = 8'd49;
        end
        8'd251:
        begin
            x = -8'd6;
            y = 8'd49;
        end
        8'd252:
        begin
            x = -8'd4;
            y = 8'd49;
        end
        8'd253:
        begin
            x = -8'd3;
            y = 8'd49;
        end
        8'd254:
        begin
            x = -8'd2;
            y = 8'd49;
        end
        8'd255:
        begin
            x = -8'd1;
            y = 8'd49;
        end
        default:
        begin
            x = 8'd0;
            y = 8'd50;
        end
        endcase;
    end
endmodule
