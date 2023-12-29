# Example software running in Logisim RISC-V Computer System model by Pavel Gladyshev
# licensed under Creative Commons Attribution International license 4.0
#
# This is a very simple program that displays digit '1' on the right-most 7-segment LED indicator
# and then loops forever

    .text
    .globl start 
    
start:
    li t0, 0xffff0010    # load memory address of the right-most LED indicator into t0
    li t1, 0x06          # load bit-pattern corresponding to digit '1' into t1
    sb t1, 0(t0)         # write the least significant byte from t1 into the LED MMIO register memory location (address in t0)
loop:
    j loop               # loop forever
