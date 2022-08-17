.data
message: 	.asciiz "\nNhap cau lenh: "
# opcode co 5 ky tu 
# 3 so phia sau lan luot la thanh ghi = 1, so nguyen = 2, ham con = 3, khong co = 0 
# so cuoi la chu ky
taplenh: 	.asciiz "add *1111;addi 1121;lui *1201;ori *1121;bne *1132;beq *1132;j ***3002;jal *3002;"
dump: 		.asciiz
thanhghi: 	.asciiz "$zero $at   $v0   $v1   $a0   $a1   $a2   $a3   $t0   $t1   $t2   $t3   $t4   $t5   $t6   $t7   $s0   $s1   $s2   $s3   $s4   $s5   $s6   $s7   $t8   $t9   $k0   $k1   "
dump1: 		.asciiz
hamconkohople: 	.asciiz "$ 0 1 2 3 4 5 6 7 8 9 "
dump2: 		.asciiz
hamconkohople1: 	.asciiz "$ . , / ? "
dump0: 		.asciiz
number: 	.asciiz "0 1 2 3 4 5 6 7 8 9 "
dump3: 		.asciiz
opcode1: 	.asciiz "Opcode: "
messtoanhang: 	.asciiz "Toan hang: "
messchuky: 	.asciiz "Chu ky: "
hople2: 	.asciiz " hop le.\n"
khonghople: 	.asciiz " khong hop le.\n"
tieptuc: 	.asciiz "Ban muon tiep tuc ?"
nhaplenh: 	.space 100
dump9: 		.asciiz
opcode: 	.space 10
dump8: 		.asciiz
tatcatoanhang: 	.space 30
dump7: 		.asciiz
toanhang: 	.space 10
dump6: 		.asciiz
tungtoanhang: 	.space 10
dump5: 		.asciiz
.text
main:
	li $v0, 54
	la $a0,message
	la $a1,nhaplenh
	la $a2,100
	syscall
# tach opcode ra khoi lenh
	la $a0,nhaplenh
	la $t1, opcode			# opcode[0]
readopcode:
	lb $t3,0($a0)			
	sb $t3,0($t1)			# luu command[i] vao opcode[j]
	beq $t3,32,xuly_opcode		# if command[i] == ' ' than xuly
	add $a0,$a0,1			# else i = i+1
	add $t1,$t1,1			#      j = j+1
	j readopcode
# hoan thanh !
# bat dau xu ly opcode
xuly_opcode:				
	la $s7,dump
   	add $s7,$s7,-1				
	la $s0,taplenh			# $s0 la thanh ghi co dinh tro den dong lenh dang duoc so sanh
	la $t1,opcode
    	add $s1,$s0,$zero
    for1:				# so sanh opcode[i] voi tung command[i]
	lb $t3,0($s1)
	lb $t4,0($t1)
	bne $t3,$t4,for2		# if opcode[i]!=command[i] than chuyen qua so sanh command khac
	addi $s1,$s1,1			# else so sanh opcode[i+1] voi command[i+1]
	addi $t1,$t1,1
	beq $t4,32,hople		# if opcode[i] = ' ' opcode khong sai => opcode hop le
	j for1
   for2:				# chuyen tu command thu j sang command thu j+1 
   	addi $s0,$s0,10			# do moi command trong taplenh dai 10 ky tu
    	li $s1,0
    	add $s1,$s0,$zero
   	beq $s0,$s7,honghople		# if command cuoi cung van khong dung => opcode sai
   	la $t1,opcode
   	j for1
hople:					# opcode hop le
	add $t9,$a0,$zero
	li $v0, 4
	la $a0, opcode1
	syscall
	li $v0, 4
	la $a0, opcode
	syscall
	
	li $v0, 4
	la $a0, hople2
	syscall
	j xuly_toanhang
honghople:				# opcode khong hop le
	li $v0, 4
	la $a0, opcode1
	syscall
	li $v0, 4
	la $a0, opcode
	syscall
	li $v0, 4
	la $a0, khonghople
	syscall
	j end
# ket thuc xu ly opcode
# bat dau xu ly toan hang
xuly_toanhang:		
# luu tat ca toan hang vao bien tatcatoanhang (ca ki tu \n)
	la $t0,tatcatoanhang
	# addi $s0,$s0,5
read_toanhang:				# bo dau cach trong phan toan hang
	lb $t3,0($t9)		
	beq $t3,32,bodau		# if toanhang[i] == ' ' than bo dau cach
	sb $t3,0($t0)			# luu toanhang[i] vao tatcatoanhang[j]
	beq $t3,10,xuly			# if toanhang[i] == '\n' than xuly
	add $t9,$t9,1			# i = i+1
	add $t0,$t0,1			# j = j+1
	j read_toanhang
   bodau:
   	add $t9,$t9,1
   	j read_toanhang
# ket thuc luu 
xuly:					# bat dau xu ly toan hang thu 1
	add $s0,$s0,5			# vi opcode co 5 ky tu va toan hang co 5 ky tu trong mac dinh
					# vi du: add *1111;
					#        |->  |
					#       s0-> s0
        la $t6,tungtoanhang		# lay tung toan hang trong
	la $t0,tatcatoanhang		# mang tat ca toan hang vua lay duoc de so sanh
	lb $t8,0($s0)
	addi $t8,$t8,-48		# chuyen ki tu thanh so nguyen de so sanh
					# theo quy uoc o tren
	beq $t8,1,xuly_thanhghi		
	beq $t8,2,xuly_songuyen
	beq $t8,3,xuly_hamcon
	beq $t8,0,xuly_rong
	j end
xuly_thanhghi:  			# neu so nguyen lay duoc la 1 thi toan hang lay ra phai la thanh ghi
	# lay toan hang
	lb $t5,0($t0)			
	sb $t5,0($t6)
	beq $t5,44,sosanh1		# gap dau ',' hoac '\n' thi da lay xong 1 toan hang ( lay ca dau , \n)
	beq $t5,10,sosanh1		# tiep theo so sanh toan hang lay duoc xem co hop le khong
	addi $t0,$t0,1
	addi $t6,$t6,1
	j xuly_thanhghi
sosanh1:				# so sanh
	la $t1,thanhghi
	la $t6,tungtoanhang
    	add $s1,$t1,$zero
    for3:				# so sanh tungtoanhang[i] voi thanhghi[i]
	lb $t3,0($s1)
	lb $t4,0($t6)
	bne $t3,$t4,for4		# if tungtoanhang[i]!=thanhghi[i] than chuyen qua so sanh thanh ghi khac
	addi $s1,$s1,1			# else so sanh tungtoanhang[i+1] voi thanhghi[i+1]
	addi $t6,$t6,1
	lb $t4,0($t6)
	beq $t4,44,toanhang_hople	# if tungtoanhang[i] = ',' hoac '\n' toan hang khong sai => toan hang hop le
	beq $t4,10,toanhang_hople
	j for3
   for4:				# chuyen tu thanh ghi thu j sang thanh ghi thu j+1 
   	addi $t1,$t1,6			# do moi thanh ghi trong thanhghi dai 6 ky tu
    	li $s1,0
    	add $s1,$t1,$zero
   	la $s7,dump1
   	add $s7,$s7,-1
   	beq $t1,$s7,toanhang_honghople	# if thanh ghi cuoi cung van khong dung => toan hang sai
   	la $t6,tungtoanhang
   	j for3
xuly_songuyen:				# neu so nguyen lay duoc la 2 thi toan hang lay ra phai la so nguyen
	# lay toan hang
	lb $t5,0($t0)			# $t0 tatcatoanhang
	sb $t5,0($t6)			# $t6 tungtoanhang
	beq $t5,44,sosanh5		# gap dau ',' hoac '\n' thi da lay xong 1 toan hang ( lay ca dau , \n)
	beq $t5,10,sosanh5		# tiep theo so sanh toan hang lay duoc xem co hop le khong
	addi $t0,$t0,1
	addi $t6,$t6,1
	j xuly_songuyen
   sosanh5:				# so sanh toan hang voi tung so trong mang number
   	la $t6,tungtoanhang
   	la $t5,number
   forn:					
   	lb $t8,0($t6)				# toanhang[i]
   	lb $t7,0($t5)				# number[j]
   	beq $t8,44,toanhang_hople		# if toanhang[i] la toan hang cuoi cung then true
   	beq $t8,10,toanhang_hople
   	beq $t7,$t8,nextSohang			# if toanhang[i] la so nguyen then i++
   	add $t5,$t5,2				# else number[j+1}
   	la $s7,dump3
   	add $s7,$s7,-1
   	beq $t5,$s7,toanhang_honghople		# if toanhang[i]!=number[end] then false
   	j forn
   nextSohang:					# toanhang[i+1}
   	add $t6,$t6,1
   	la $t5,number
   	j forn
xuly_hamcon:				# neu so nguyen lay duoc la 3 thi toan hang lay ra phai la ham con
	# lay toan hang
	lb $t5,0($t0)			# $t0 tatcatoanhang
	sb $t5,0($t6)			# $t6 tungtoanhang
	beq $t5,44,sosanh3		# gap dau ',' hoac '\n' thi da lay xong 1 toan hang
	beq $t5,10,sosanh3		# tiep theo so sanh toan hang lay duoc xem co hop le khong
	addi $t0,$t0,1
	addi $t6,$t6,1
	j xuly_hamcon
   sosanh3:				# so sanh
   	la $t6,tungtoanhang		# lay phan tu dau tien cua toan hang de so sanh
   	lb $t5,0($t6)
   	la $s5,hamconkohople
   	la $s7,dump2
   	add $s7,$s7,-1
   # xu ly tungtoanhang[0]
     for5:
   	lb $s4,0($s5)
   	beq $t5,$s4,toanhang_honghople		# if tungtoanhang[0] = toanhangkohople[i] then error
   	addi $s5,$s5,2
   	beq $s5,$s7,kytu_tiep			# else xu ly cac ky tu thu 2 tro di
   	j for5
   # xu ly tungtoanhang[0++]
     kytu_tiep:
     	addi $t6,$t6,1
     	lb $t5,0($t6)
     	beq $t5,44,toanhang_hople		# tungtoanhang[i] = ',' or '\n' ma khong sai => dung
	beq $t5,10,toanhang_hople
     	la $s5,hamconkohople1
     	la $s7,dump0
     	addi $s7,$s7,-1
     loop:
     	lb $s4,0($s5)
   	beq $t5,$s4,toanhang_honghople		# if tungtoanhang[j] = toanhangkohople1[i] then error
   	addi $s5,$s5,2
   	beq $s5,$s7,kytu_tiep			# else ky tu tiep theo
   	j loop
xuly_rong:					# neu so nguyen lay duoc la 0 thi toan hang lay ra phai khong co gi
	# lay ky tu dau tien cua toan hang neu no khac rong thi sai
	lb $t5,0($t0)			# $t0 tatcatoanhang
	sb $t5,0($t6)			# $t6 tungtoanhang
	beq $t5,44,sosanh4		# gap dau ',' hoac '\n' thi da lay xong 1 toan hang
	beq $t5,10,sosanh4
   sosanh4:
   	lb $t5,0($t6)
   	beq $t5,0,rong			# if tungtoanhang[i] == \0 then true
   	j toanhang_honghople		# else false
toanhang_hople:
	li $v0, 4
	la $a0, messtoanhang
	syscall
	li $v0, 4
	la $a0, tungtoanhang
	syscall
	li $v0, 4
	la $a0, hople2
	syscall
	
	# reset tungtoanhang
	la $t6, tungtoanhang
reset:	li $s7,0
	sb $s7,0($t6)
	la $s7,dump5
	addi $s7,$s7,-1
	add $t6,$t6,1
	beq $t6,$s7,continue
	j reset
continue:
	add $t0,$t0,1		
	addi $v1, $v1, 1 # dem so toan hang da doc
	beq $v1, 1, read_toanhang2
	beq $v1, 2, read_toanhang3
	beq $v1, 3, read_chuky
	j end
toanhang_honghople:
	li $v0, 4
	la $a0, messtoanhang
	syscall
	li $v0, 4
	la $a0, tungtoanhang
	syscall
	li $v0, 4
	la $a0, khonghople
	syscall
	j end
read_toanhang2:
	add $s0,$s0,1
        la $t6,tungtoanhang
	lb $t8,0($s0)
	addi $t8,$t8,-48
	beq $t8,1,xuly_thanhghi
	beq $t8,2,xuly_songuyen
	beq $t8,3,xuly_hamcon
	beq $t8,0,xuly_rong
	j end
read_toanhang3:
	add $s0,$s0,1
        la $t6,tungtoanhang
	lb $t8,0($s0)
	addi $t8,$t8,-48
	beq $t8,1,xuly_thanhghi
	beq $t8,2,xuly_songuyen
	beq $t8,3,xuly_hamcon
	beq $t8,0,xuly_rong
	j end
read_chuky:
	add $s0,$s0,1
        la $t6,tungtoanhang
	lb $t8,0($s0)
	addi $t8,$t8,-48
	li $v0, 4
	la $a0, messchuky
	syscall
	li $v0,1
	li $a0,0
	add $a0,$t8,$zero
	syscall
	j end
rong:
	add $t0,$t0,1		
	addi $v1, $v1, 1 # dem so toan hang da doc
	beq $v1, 1, read_toanhang2
	beq $v1, 2, read_toanhang3
	beq $v1, 3, read_chuky
	j end
end:
	li $v0, 50
	la $a0, tieptuc
	syscall
# reset cac vung nho tam thoi
	la $t6, tungtoanhang
	la $t5, toanhang
	la $t4, tatcatoanhang
	la $t3, opcode
	la $t2, nhaplenh
reset_tungtoanhang:	
	li $s7,0
	sb $s7,0($t6)
	la $s7,dump5
	addi $s7,$s7,-1
	add $t6,$t6,1
	beq $t6,$s7,reset_toanhang
	j reset_tungtoanhang
reset_toanhang:
	li $s7,0
	sb $s7,0($t5)
	la $s7,dump6
	addi $s7,$s7,-1
	add $t5,$t5,1
	beq $t5,$s7,reset_tatcatoanhang
	j reset_toanhang
reset_tatcatoanhang:
	li $s7,0
	sb $s7,0($t4)
	la $s7,dump7
	addi $s7,$s7,-1
	add $t4,$t4,1
	beq $t4,$s7,reset_opcode
	j reset_tatcatoanhang
reset_opcode:
	li $s7,0
	sb $s7,0($t3)
	la $s7,dump8
	addi $s7,$s7,-1
	add $t3,$t3,1
	beq $t3,$s7,reset_nhaplenh
	j reset_opcode
reset_nhaplenh:
	li $s7,0
	sb $s7,0($t2)
	la $s7,dump9
	addi $s7,$s7,-1
	add $t2,$t2,1
	beq $t2,$s7,resetxong
	j reset_nhaplenh
resetxong:
	li $v0, 0 
	li $v1, 0
	li $a1, 0
	li $a2, 0
	li $a3, 0
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0
	li $s5, 0
	li $s6, 0
	li $s7, 0
	li $k0, 0
	li $k1, 0
	beq $a0,$zero,main
	j ketthuc
ketthuc:
