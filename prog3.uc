# Eduardo Leanos
# All fields are in hex format
# 
# address
# uc_addr_mux[2]    next insn addr = uc_next_addr, flags, IR opcode
# uc_alu_func[2]    0 = add, 1 = xor, 2 = and, 3 = or
# uc_alu_comp_b     1 = compliment b
# uc_alu_ci         1 = carry in
# uc_alu_flags_clk  1 = clock the flag latch
# uc_mar_we         1 = clock a write into MAR
# uc_mem_we         1 = clock a write into the RAM
# uc_mbr_out_we     1 = clock a write into the MBR_out latch
# uc_mbr_in_we      1 = clock a write into the MBR_in latch
# uc_reg_we_clk     1 = clock a write intot he register file
# uc_reg_addr_ir    0 = use reg addr from uc, 1 = use the a field address from IR 
# uc_reg_addr[3]    the uc destination register address if writing 
# uc_alu_reg_a_ir   0 = set alu_reg_a mux using the uc address, 1 = use the a field from the IR
# uc_alu_reg_a[3]   uc address for alu_reg_a
# uc_alu_reg_b_ir   0 = set alu_reg_b mux using the uc address, 1 = use the b field from the IR
# uc_alu_reg_b[3]   uc address for alu_reg_b
# uc_next_addr[16]  uc next instruction

# read a byte from memory and put it into the IR

0000 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # do nothing

#############################
# fetch an insn from PC address 
0001 0  0 0 0  0 1 0 0 0  0 0 5  0 4 0 7 0002   # put the PC reg value into the MAR
0002 0  0 0 0  0 0 0 0 1  0 0 5  0 4 0 7 0003   # falling edge on uc_mar_we, rising edge on uc_mbr_in_we
0003 0  0 0 0  0 0 0 0 0  0 0 5  0 4 0 7 0004   # falling edge on uc_mbr_in_we
0004 0  0 0 0  0 0 0 0 0  1 0 5  0 7 0 4 0005   # rising edge on uc_reg_we_clk w/ir as target
0005 0  0 0 0  0 0 0 0 0  0 0 5  0 7 0 4 0006   # falling edge on uc_reg_we_clk

# add 1 to PC
0006 0  0 0 1  0 0 0 0 0  1 0 4  0 4 0 7 0007   # add 1 to PC & rising edge on uc_reg_we_clk
0007 0  0 0 1  0 0 0 0 0  0 0 4  0 4 0 7 0010   # falling edge on uc_reg_we_clk

#############################
# instruction decode logic
0010 2  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 00f0   # branch based on the opcode in the IR!

00f0 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1000   # opcode 0 NOP
00f1 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1100   # opcode 1 LD Ra,imm
00f2 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1200   # opcode 2 ST Ra,imm
00f3 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1300   # opcode 3 ADD Ra,Rb
00f4 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1400   # opcode 4 SUB Ra,Rb
00f5 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1500   # opcode 5 XOR Ra,Rb
00f6 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1600   # opcode 6 AND Ra,Rb
00f7 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1700   # opcode 7 OR Ra,Rb
00f8 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1800   # opcode 8 MOV Ra,Rb
00f9 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1900   # opcode 9 LD Ra,mem(imm)
00fa 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1a00   # opcode a B imm (absolute)
00fb 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1b00   # opcode b BR PC+imm
00fc 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c00   # opcode c BZ PC+imm
00fd 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d00   # opcode d BNZ PC+imm
00fe 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 ffff   # opcode e
00ff 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 ffff   # opcode f HALT

############################# 2.1
# NOP no operation
1000 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # go to insn fetch

############################# 2.2
# LD Ra,imm
# fetch the byte in memory that the PC is pointing to now
1100 0  0 0 0  0 1 0 0 0  0 0 7  0 4 0 7 1101   # MAR <- PC
1101 0  0 0 0  0 0 0 0 0  0 0 7  0 4 0 7 1102   #
1102 0  0 0 0  0 0 0 0 1  0 0 7  0 7 0 7 1103   # MBR_IN <- d_in
1103 0  0 0 0  0 0 0 0 0  0 0 7  0 7 0 7 1104   #
1104 0  0 0 0  0 0 0 0 0  1 1 7  0 7 0 4 1105   # Ra <- MBR_IN
1105 0  0 0 0  0 0 0 0 0  0 1 7  0 7 0 4 1106   #
1106 0  0 0 1  0 0 0 0 0  1 0 4  0 4 0 7 1107   # PC <- PC+1
1107 0  0 0 1  0 0 0 0 0  0 0 4  0 4 0 7 1108   # 

1108 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # go to insn fetch

############################# 2.3
# ST Ra, imm 
# Store the contents or register Ra memory at the absolute address that appears
# in the instruction stream immediately after the instruction opcode
1200 0  0 0 0  0 1 0 0 0  0 0 7  0 4 0 7 1201   # MAR <- PC
1201 0  0 0 0  0 0 0 0 0  0 0 7  0 4 0 7 1202   #
1202 0  0 0 0  0 0 0 0 1  0 0 7  0 7 0 7 1203   # MBR_IN <- d_in
1203 0  0 0 0  0 0 0 0 0  0 0 7  0 7 0 7 1204   #
1204 0  0 0 0  0 1 0 0 0  0 0 7  0 7 0 4 1205   # MAR <- MBR_IN
1205 0  0 0 0  0 0 0 0 0  0 0 7  0 7 0 4 1206   #
1206 0  0 0 0  0 0 0 1 0  0 0 7  1 7 0 7 1207   # MBR_OUT <- Ra
1207 0  0 0 0  0 0 0 0 0  0 0 7  1 7 0 7 1208   #
1208 0  0 0 0  0 0 1 0 0  0 0 7  0 7 0 7 1209   # mem(MAR) <- MBR_OUT
1209 0  0 0 0  0 0 0 0 0  0 0 7  0 7 0 7 1210   #
1210 0  0 0 1  0 0 0 0 0  1 0 4  0 4 0 7 1211   # PC <- PC+1
1211 0  0 0 1  0 0 0 0 0  0 0 4  0 4 0 7 1212   # 

1212 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # go to insn fetch

############################# 2.4
# ADD Ra,Rb
# Add the contents of Ra with Rb
1300 0  0 0 0  1 0 0 0 0  1 1 7  1 7 1 7 1301   # Ra <- Ra + Rb, FLAGS <- ALU_status
1301 0  0 0 0  0 0 0 0 0  0 1 7  1 7 1 7 1302   #

1302 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # go to insn fetch

############################# 2.5
# SUB Ra,Rb
# Subtract the contents of Ra with Rb
1400 0  0 1 1  1 0 0 0 0  0 0 7  1 7 1 7 1401   # FLAGS <- ALU_status
1401 0  0 1 1  0 0 0 0 0  0 0 7  1 7 1 7 1402
1402 0  0 1 1  0 0 0 0 0  1 1 7  1 7 1 7 1403   # Ra <- Ra - Rb
1403 0  0 1 1  0 0 0 0 0  0 1 7  1 7 1 7 1404   #

1404 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # go to insn fetch

############################# 2.6
# XOR Ra,Rb
# Exclusive the contents of Ra with Rb
1500 0  1 0 0  1 0 0 0 0  1 1 7  1 7 1 7 1501   # Ra <- Ra XOR Rb, FLAGS <- ALU_status
1501 0  1 0 0  0 0 0 0 0  0 1 7  1 7 1 7 1502   #														
1502 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # go to insn fetch

############################# 2.7
# AND Ra,Rb
# AND the contents of Ra with Rb
1600 0  2 0 0  1 0 0 0 0  1 1 7  1 7 1 7 1601   # Ra <- Ra ^ Rb, FLAGS <- ALU_status
1601 0  2 0 0  0 0 0 0 0  0 1 7  1 7 1 7 1602   #

1602 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # go to insn fetch

############################# 2.8
# OR Ra,Rb
# Either the contents of Ra with Rb
1700 0  3 0 0  1 0 0 0 0  1 1 7  1 7 1 7 1701   # Ra <- Ra OR Rb, FLAGS <- ALU_status
1701 0  3 0 0  0 0 0 0 0  0 1 7  1 7 1 7 1702   #


1702 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # go to insn fetch

############################# 2.9
# MOV Ra,Rb
# Either the contents of Ra with Rb
1800 0  0 0 0  0 0 0 0 0  1 1 7  0 7 1 7 1801   # Ra <- Rb
1801 0  0 0 0  0 0 0 0 0  0 1 7  0 7 1 7 1802   #

1802 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # go to insn fetch

############################# 2.10
# LD Ra,mem(imm) 
# Load the contents of a memory byte from the address that appears in the instruction
# stream immediately after the opcode into register Ra
1900 0  0 0 0  0 1 0 0 0  0 0 7  0 4 0 7 1901   # MAR <- PC
1901 0  0 0 0  0 0 0 0 0  0 0 7  0 4 0 7 1902   #
1902 0  0 0 0  0 0 0 0 1  0 0 7  0 7 0 7 1903   # MBR_IN <- d_in
1903 0  0 0 0  0 0 0 0 0  0 0 7  0 7 0 7 1904   #
1904 0  0 0 0  0 1 0 0 0  0 0 7  0 7 0 4 1905   # MAR <- MBR_IN
1905 0  0 0 0  0 0 0 0 0  0 0 7  0 7 0 4 1906   #
1906 0  0 0 0  0 0 0 0 1  0 0 7  0 7 0 7 1907   # MBR_IN <- d_in
1907 0  0 0 0  0 0 0 0 0  0 0 7  0 7 0 7 1908   #
1908 0  0 0 0  0 0 0 0 0  1 1 7  0 7 0 4 1909   # Ra <- MBR_IN
1909 0  0 0 0  0 0 0 0 0  0 1 7  0 7 0 4 1910   #
1910 0  0 0 1  0 0 0 0 0  1 0 4  0 4 0 7 1911   # PC <- PC+1
1911 0  0 0 1  0 0 0 0 0  0 0 4  0 4 0 7 1912   # 

1912 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # go to insn fetch

############################# 2.11
# B imm  
# Branch to the absolute adress in the byte that appears in the instrustion stream
# immediately after the instruction opcode.

1a00 0  0 0 0  0 1 0 0 0  0 0 7  0 4 0 7 1a01   # MAR <- PC
1a01 0  0 0 0  0 0 0 0 0  0 0 7  0 4 0 7 1a02   #
1a02 0  0 0 0  0 0 0 0 1  0 0 7  0 7 0 7 1a03   # MBR_IN <- d_in
1a03 0  0 0 0  0 0 0 0 0  0 0 7  0 7 0 7 1a04   #
1a04 0  0 0 0  0 0 0 0 0  1 0 4  0 7 0 4 1a05   # PC <- MBR_IN
1a05 0  0 0 0  0 0 0 0 0  0 0 4  0 7 0 4 1a06   #

1a06 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # go to insn fetch

############################# 2.12
# BR PC+imm  
# Branch to the byte that appears in the in struction
# stream immediately after the instruction opcode plus program counter
1b00 0  0 0 0  0 1 0 0 0  0 0 7  0 4 0 7 1b01   # MAR <- PC
1b01 0  0 0 0  0 0 0 0 0  0 0 7  0 4 0 7 1b02   #
1b02 0  0 0 1  0 0 0 0 0  1 0 4  0 4 0 7 1b03   # PC <- PC+1
1b03 0  0 0 1  0 0 0 0 0  0 0 4  0 4 0 7 1b04   # 
1b04 0  0 0 0  0 0 0 0 1  0 0 7  0 7 0 7 1b05   # MBR_IN <- d_in
1b05 0  0 0 0  0 0 0 0 0  0 0 7  0 7 0 7 1b06   #
1b06 0  0 0 0  0 0 0 0 0  1 0 4  0 4 0 4 1b07   # PC <- PC + MBR_IN
1b07 0  0 0 0  0 0 0 0 0  0 0 4  0 4 0 4 1b08   #

1b08 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # go to insn fetch

############################# 2.13
# BZ PC+imm  

#if
1c00 1  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1cf0   # Branch if zero

#do
1c01 0  0 0 0  0 1 0 0 0  0 0 7  0 4 0 7 1c02   # MAR <- PC
1c02 0  0 0 0  0 0 0 0 0  0 0 7  0 4 0 7 1c03   #
1c03 0  0 0 1  0 0 0 0 0  1 0 4  0 4 0 7 1c04   # PC <- PC+1
1c04 0  0 0 1  0 0 0 0 0  0 0 4  0 4 0 7 1c05   # 
1c05 0  0 0 0  0 0 0 0 1  0 0 7  0 7 0 7 1c06   # MBR_IN <- d_in
1c06 0  0 0 0  0 0 0 0 0  0 0 7  0 7 0 7 1c07   #
1c07 0  0 0 0  0 0 0 0 0  1 0 4  0 4 0 4 1c08   # PC <- PC + MBR_IN
1c08 0  0 0 0  0 0 0 0 0  0 0 4  0 4 0 4 1c11   #

#else
1c09 0  0 0 1  0 0 0 0 0  1 0 4  0 4 0 7 1c10   # PC <- PC+1
1c10 0  0 0 1  0 0 0 0 0  0 0 4  0 4 0 7 1c11   # 

1c11 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # go to insn fetch


############
# instruction decode logic

1cf0 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c09   # opcode 0 
1cf1 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c09   # opcode 1 
1cf2 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c01   # opcode 2 
1cf3 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c01   # opcode 3 
1cf4 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c09   # opcode 4 
1cf5 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c09   # opcode 5
1cf6 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c01   # opcode 6 
1cf7 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c01   # opcode 7 
1cf8 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c09   # opcode 8
1cf9 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c09   # opcode 9
1cfa 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c01   # opcode a 
1cfb 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c01   # opcode b 
1cfc 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c09   # opcode c 
1cfd 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c09   # opcode d 
1cfe 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c01   # opcode e
1cff 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1c01   # opcode f 


############################# 2.14
# BNZ PC+imm  

#if
1d00 1  0 0 0  0 0 0 0 0  0 0 0  0 0 0 0 1df0   # Branch if not Zero

#do
1d01 0  0 0 0  0 1 0 0 0  0 0 7  0 4 0 7 1d02   # MAR <- PC
1d02 0  0 0 0  0 0 0 0 0  0 0 7  0 4 0 7 1d03   #
1d03 0  0 0 1  0 0 0 0 0  1 0 4  0 4 0 7 1d04   # PC <- PC+1
1d04 0  0 0 1  0 0 0 0 0  0 0 4  0 4 0 7 1d05   # 
1d05 0  0 0 0  0 0 0 0 1  0 0 7  0 7 0 7 1d06   # MBR_IN <- d_in
1d06 0  0 0 0  0 0 0 0 0  0 0 7  0 7 0 7 1d07   #
1d07 0  0 0 0  0 0 0 0 0  1 0 4  0 4 0 4 1d08   # PC <- PC + MBR_IN
1d08 0  0 0 0  0 0 0 0 0  0 0 4  0 4 0 4 1d11   #

#else
1d09 0  0 0 1  0 0 0 0 0  1 0 4  0 4 0 7 1d10   # PC <- PC+1
1d10 0  0 0 1  0 0 0 0 0  0 0 4  0 4 0 7 1d11   # 

1d11 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 0001   # go to insn fetch


#############
# instruction decode logic

1df0 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d01   # opcode 0
1df1 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d01   # opcode 1 
1df2 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d09   # opcode 2 
1df3 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d09   # opcode 3 
1df4 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d01   # opcode 4 
1df5 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d01   # opcode 5
1df6 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d09   # opcode 6 
1df7 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d09   # opcode 7 
1df8 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d01   # opcode 8 
1df9 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d01   # opcode 9 
1dfa 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d09   # opcode a 
1dfb 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d09   # opcode b 
1dfc 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d01   # opcode c 
1dfd 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d01   # opcode d 
1dfe 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d09   # opcode e
1dff 0  0 0 0  0 0 0 0 0  0 0 0  0 7 0 7 1d09   # opcode f



