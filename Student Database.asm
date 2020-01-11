.data
enterdata: .asciiz "\t*********Enter Data For Student *********\n"
entername: .asciiz "Enter Name : "
entercontact: .asciiz "\nEnter Contact : "
enteraddress: .asciiz "\nEnter Address : "
enterid: .asciiz "\nEnter ID : "
newline: .asciiz "\n"
delprompt: .asciiz "\nDeleted...\n"
nameprompt: .asciiz "\nName : "
phoneprompt: .asciiz "Phone : "
addressprompt : .asciiz "Address : "
contactprompt : .asciiz "Contact : "
idprompt: .asciiz "ID : "
searchtemp: .space 20
space: .asciiz " "
choice: .asciiz "Enter Your Choice : "
prompt: .asciiz "\n\t*********** Telephone Directory *************\n1.Add Entry \n2.Search\n3.Delete\n4.Edit\n5.Exit\n"
searchmenu: .asciiz "\n\tSearch Menu\n"
NameFound: .asciiz "Found in the Directory...\n"
NameNotFound: .asciiz "Not Found in the Directory...\n"
editprompt: .asciiz "\nWhat to change ? \n1.Name\n2.Address\n3.Contact\n   Enter Your Choice : "
changeprompt: .asciiz "\nChanged...\n"
name: .space 340
contact: .space 340
address: .space 340
id: .space 340
edittemp: .space 20

#''''''''''''''''''''''''''''''''MACROS'''''''''''''''''''''''''''''
#''''''''''''''''''
  .macro MainMenu
  enterchoice:
  li $v0,4
la $a0,prompt
syscall
  li $v0,4
la $a0,choice
syscall
li $v0,5
syscall
move $s0,$v0
beq $s0,1,one
beq $s0,2,two
beq $s0,3,three
beq $s0,4,four
beq $s0,5,five
one:
enterData
two:
search
three:
delete
four:
edit
five:
li $v0,10
syscall
.end_macro 
#''''''''''''''''''

.macro enterData
li $t0,0
li $t1,0
li $t2,0

li $v0,4
la $a0,enterdata
syscall
#enter 	ID
li $v0,4
la $a0,enterid
syscall


li $v0,5
syscall
sb $v0,id($t6)
#enter name
li $v0,4
la $a0,entername
syscall
la $a0,name($t7)
li $a1,20
li $v0,8
syscall

#enter contact
li $v0,4
la $a0,entercontact
syscall 
la $a0,contact($t8)
li $a1,12
li $v0,8
syscall
#enter address
li $v0,4
la $a0,enteraddress
syscall
la $a0,address($t7)
li $a1,19
li $v0,8
syscall
addi $t7,$t7,20
addi $t6,$t6,4
addi $t8,$t8,12

j main
.end_macro 
   #''''''''''''''''''

.macro search
li $t0, 0
  li $t1, 0
  li $t2, 0
  li $t3, 0
  
li $v0,4
la $a0,searchmenu
syscall

li $v0,4
la $a0,entername
syscall

li $v0,8
la $a0,searchtemp
li $a1,20
syscall

searchwhile:
    bge $t3, 20, Found  #loop ran for 20 indexes means it did'nt jump on bne means Name found
    bge $t2, 40, notFound  #Array ended
    lb $s0, name($t0)
    lb $s1, searchtemp($t1)
    bne $s0,  $s1, increment   
    addi $t0, $t0, 1#t0 for check name array from start of new name's index
    addi $t1, $t1, 1#t1 for name enter by user
    addi $t3, $t3, 1#t3  to count the track of bytes loaded to compare 
    j searchwhile
  increment:
    addi $t2, $t2, 1
    li $t1, 0
    li $t3,0
    mul $t0, $t2, 20
    j searchwhile
    
    
  Found:
  mul $t9,$t2,4
  mul $t2,$t2,12
  addi $t0,$t0,-20
  li $v0, 4
    la $a0,NameFound
    syscall
    
    
    
    li $v0,4
    
    la $a0,idprompt
    syscall
    li $v0,1
    lb $a0,id($t9)
    syscall
    
    li $v0,4
    la $a0,nameprompt
    syscall
    la $a0,name($t0)
    syscall
    
    la $a0,addressprompt
    syscall
    la $a0,address($t0)
    syscall
    
    la $a0,contactprompt
    syscall
    la $a0,contact($t2)
    syscall
    
    j next
  notFound:
    li $v0, 4
    la $a0, NameNotFound
    syscall
    j next
    next:
    j main
.end_macro 
   #'''''''''''''''''''''''''''''''''''''
.macro delete

  li $t0, 0
  li $t1, 0
  li $t2, 0
  li $t3, 0
  
  
    li $v0,4
  la $a0,enterid
  syscall
  
  li $v0,5
  syscall
  move $t0,$v0
  
  
  whiledelete:
  lb $t1,id($t2)
  beq $t0,$t1,found
  beq $t2,20,notfound
  addi $t2,$t2,4
  addi $t3,$t3,1 #temp to count indext so we can find its index in name etc.
  j whiledelete
  
  notfound:
  li $v0,4
  la $a0,NameNotFound
  syscall
  j nextone
  found:
  li $v0,4
  la $a0,NameFound
  syscall
  mul $t9,$t3,4
  mul $t2,$t3,12
  mul $t3,$t3,20
  
  #Display Id
    la $a0,idprompt
    syscall
    li $v0,1
    lb $a0,id($t9)
    syscall
  
  #......Display Name ....
  li $v0,4
    la $a0,nameprompt
    syscall
  
  la $a0,name($t3)
  syscall
  #...Display Address
    la $a0,addressprompt
    syscall
    
    la $a0,address($t3)
  syscall
  #..Display Contact
    la $a0,contactprompt
    syscall
    la $a0,contact($t2)
  syscall
  
  
  addi $t4,$t3,20 
  li $t5,0
  #Loop to empty space in Array
  emptyloop:
  #storing 0 in name,contact ,address
  beq $t4,$t3,nextone
  sb $t5,id($t9)
  sb $t5,name($t3)
  sb $t5,address($t3)
  sb $t5,address($t2)
  addi $t3,$t3,1
  j emptyloop
  
 nextone:
  sub $t3,$t3,20
  la $a0,name($t3)
  syscall
  li $v0,4
  la $a0,delprompt
    syscall
  j main
.end_macro 
   #'''''''''''''''''''''''''''''''''''''
   .macro edit
   
     li $t0, 0
  li $t1, 0
  li $t2, 0
  li $t3, 0
  li $t9,0
  
  li $v0,4
  la $a0,enterid
  syscall
  
  li $v0,5
  syscall
  move $t0,$v0
    whileedit:
  lb $t1,id($t2)
  beq $t0,$t1,idfound
  beq $t2,20,idnotfound
  addi $t2,$t2,4
  addi $t3,$t3,1 #temp to count indext so we can find its index in name etc.
  j whileedit
  
  idnotfound:
  li $v0,4
  la $a0,NameNotFound
  syscall
  j main
  
  idfound:
  li $v0,4
  la $a0,NameFound
  syscall
  
  
 
 la $a0,editprompt
 syscall
 
 li $v0,5
 syscall
 
 beq $v0,1,editname
 beq $v0,2,editaddress
 beq $v0,3,editcontact
  
  editname:
    mul $t3,$t3,20

  li $v0,4
  la $a0,entername
  syscall
  
  li $v0,8
  addi $t4,$t3,20
  
  editloop:
  beq $t4,$t3,end
  sb $t5,name($t3)
  addi $t3,$t3,1
  j editloop
  
  editaddress:
    mul $t3,$t3,20

   li $v0,4
  la $a0,enteraddress
  syscall
  
  li $v0,8
  addi $t4,$t3,20
  
  editaddressloop:
  beq $t4,$t3,addressend
  sb $t5,address($t3)
  addi $t3,$t3,1
  j editaddressloop
  
  editcontact:
    mul $t9,$t3,12

   li $v0,4
  la $a0,entercontact
  syscall
  
  li $v0,8

  addi $t4,$t9,12
  
  editcontactloop:
  beq $t4,$t9,contactend
  sb $t5,contact($t9)
  addi $t9,$t9,1
  j editcontactloop
  
  end:
  sub $t3,$t3,20
  la $a0,name($t3)
  syscall
  
  li $v0,4
  la $a0,changeprompt
  syscall
  j main
  addressend:
  sub $t3,$t3,20
  la $a0,address($t3)
  syscall
  li $v0,4
  la $a0,changeprompt
  syscall
  j main
  
  contactend:
  sub $t9,$t9,12
  la $a0,contact($t9)
 li $a1,12
  syscall
  li $v0,4
  la $a0,changeprompt
  syscall
  j main
  
.end_macro 
   #'''''''''''''''''''''''''''''''''''''

.macro Filing

Openfile#open file
  li   $v0, 15       
  move $a0, $s6      
  la   $a1, name   
  li   $a2, 20       
  syscall
Writenewline
li   $v0, 15       
  move $a0, $s6      
  la   $a1, contact   
  li   $a2, 20       
  syscall
Writenewline
li   $v0, 15       
  move $a0, $s6      
  la   $a1, address   
  li   $a2, 20       
  syscall
   Writenewline
   next:
  Closefile
  .end_macro 
.text  
main:
MainMenu
   teqi $t0,0     # immediately trap because $t0 contains 0
   li   $v0, 10   # After return from exception handler, specify exit service
   syscall        # terminate normally

# Trap handler in the standard MIPS32 kernel text segment

   .ktext 0x80000180
   move $k0,$v0   # Save $v0 value
   move $k1,$a0   # Save $a0 value
   la   $a0, msg  # address of string to print
   li   $v0, 4    # Print String service
   syscall
   move $v0,$k0   # Restore $v0
   move $a0,$k1   # Restore $a0
   mfc0 $k0,$14   # Coprocessor 0 register $14 has address of trapping instruction
   addi $k0,$k0,4 # Add 4 to point to next instruction
   move $k0,$14   # Store new address back into $14
   eret           # Error return; set PC to value in $14
   .kdata	
msg:   
   .asciiz "\nInvalid ID.....\n"
exit:
li $v0,10
syscall
