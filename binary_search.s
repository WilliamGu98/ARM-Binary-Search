//r0    numbers (base address of array) and return index
//r1    key
//r2    start index
//r3    end index
//r4    used for middle index
//r5    used for number of calls
//r6    used for numbers[middle index]

.globl binary_search
binary_search:
	SUB sp, sp, #28    //adjust stack for 6 items, top address contains numCalls

	STR R2, [sp, #20]  //save start index
	STR R3, [sp, #16]  //save end index
	STR R4, [sp, #12]  //save R4 to restore later
	STR R5, [sp, #8]   //save R5 to restore later
	STR R6, [sp, #4]   //save R6 to restore later
	STR lr, [sp, #0]   //save the return address
	
	LDR R5, [sp, #24]  //get the prev number of calls (extra parameter)
	ADD R5, R5, #1     //increase number of calls by 1 (r5 = current numCalls)
	STR R5, [sp, #-4]  //pass new number of calls to next recursive call
	
	//Calculate middle index
	SUB R4, R3, R2 	         //r4 = endIndex-startIndex
	ADD R4, R2, R4, LSR #1   //r4 = middle index = (start) + (end-start)/2
	
	//Terminate condition (startIndex > endIndex)
	CMP R2, R3
	BGT noSol
	
	LDR R6, [R0, R4, LSL#2]  //get value of numbers[middleIndex]
	RSB R5, R5, #0           //get negative of numcalls
	STR R5, [R0, R4, LSL#2]  //store negative of numcalls into numbers[middleIndex]
	
	CMP R6, R1
	BEQ equal       //if numbers[middleIndex]==key
	BGT greater     //if numbers[middleIndex]>key
	BLT less        //if numbers[middleIndex]<key


noSol: 
	MOV R0, #-1     //return -1
	B return        //restore registers and go back

		
equal:
	MOV R0, R4      //return middleindex if we find key
	B return        //restore registers and go back

	
greater:
	//update r0~r3 going into recursion (numCalls was already updated)
	SUB R4, R4, #1	    //middleIndex-1
	MOV R3, R4	    //endIndex=middleIndex-1

	BL binary_search    //recursive call
	B return            //restore registers and go back

	
less:
	//update r0~r3 going into recursion (numCalls was already updated)
	ADD R4, R4, #1      //middleIndex+1
	MOV R2, R4          //startIndex=middleIndex+1

	BL binary_search    //recursive call
	B return            //restore registers and step out one level


return:
	//Restore registers we saved
	LDR R2, [sp, #20]
	LDR R3, [sp, #16]
	LDR R4, [sp, #12]
	LDR R5, [sp, #8]
	LDR R6, [sp, #4]
	LDR lr, [sp, #0]
	ADD sp, sp, #28   //pop stack
	
	MOV pc, lr        //step out one level
