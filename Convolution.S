.import input.S

.text
main:
    # 获取图像和卷积核的尺寸
    lw a4, image_width
    lw a5, image_length
    lw a2, kernel_width
    lw a3, kernel_length
    # 数组中一个元素的步长
    addi s1, x0, 4

    # 计算卷积结果矩阵的尺寸
    sub t0, a4, a2
    addi t0, t0, 1
    sub t1, a5, a3
    addi t1, t1, 1

    # 设置图像和卷积核的起始地址
    la t2, image
    la t3, kernel

    # 卷积运算的外层循环（遍历图像的行）
    li t4, 0  # 行索引
    conv_row_loop:
    li t5, 0  # 列索引
    blt t4, t0, conv_col_loop  # 如果行索引小于卷积结果矩阵的行数，则继续
    j conv_end

    # 卷积运算的内层循环（遍历图像的列）
    
    conv_col_loop:
    blt t5, t1, conv_compute  # 如果列索引小于卷积结果矩阵的列数，则继续
    
    addi a1, x0, 10
    li a0, 11
    ecall
    
    addi t4, t4, 1  # 移动到下一行
    j conv_row_loop

    # 卷积计算
    conv_compute:
    # 初始化累加器为0
    li t6, 0

    # 遍历卷积核的每个元素
    li s3, 0  # 卷积核行索引
    kernel_row_loop:
    li s4 , 0# 卷积核列索引
    blt s3, a2, kernel_col_loop
    addi t5, t5, 1  # 移动到下一列
    #
    add a1, x0, t6
    li a0, 1
    ecall
    addi a1, x0, 32
    li a0, 11
    ecall
    #

    j conv_col_loop

    kernel_col_loop:
    blt s4, a3, multiply_accumulate

    addi s3, s3, 1  # 移动到卷积核的下一行
    j kernel_row_loop

    # 乘法和累加
    multiply_accumulate:
    # 计算图像和卷积核当前元素的地址
    li s8, 0
    li s9, 0
    add s8, s3, s8
    add s9, t4, s9
    mul s8, s8, a5
    mul s9, s9, a5 
    add s5, s8, s9
    add s5, s5, t5
    add s5, s5, s4
    mul s5, s5, s1
    add s5, s5, t2
    
    mul s6, s3, a3
    add s6, s6, s4
    mul s6, s6, s1
    add s6, s6, t3

    addi s4, s4, 1  # 移动到卷积核的下一列

    # 加载图像和卷积核的当前元素
    lw s7, 0(s5)
    lw s6, 0(s6)

    # 执行乘法和累加
    mul s7, s7, s6
    add t6, t6, s7

    j kernel_col_loop

    conv_end:
    li a0, 10
    ecall
