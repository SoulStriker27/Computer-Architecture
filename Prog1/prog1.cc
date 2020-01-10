/**********************************************************************************
* Program 1 - Binary Integers
*
* Name: Eduardo Leanos
*
* Description: A program that can add and subtracts two's compliment and unsigned
* binary numbers up to 512 bits long
*
***********************************************************************************/

#include <fstream>
#include <iostream>
#include <iomanip>
#include <cstring>

using namespace std;

int addBinary(char[], char[], char[], int, int&, int&, int&, int&);  //Prototypes for addbinary and flip
void flip(char[], char [], int);

int main(){
	ifstream infile;  //Make ifstream variable
	char arr1[513];
	char arr2[513];

	char even[5] = {'e','v','e','n','\0'}; //Even and odd char arrays
	char odd[4] = {'o','d','d','\0'};
	char* point1; //pointers to even or odd for arr1
	char* point2; //			""				arr2				
	char* point3; //			""				tempArr

	infile.open("testdata"); //Open test data file
	
	if(infile.fail()){ //Proc if it fails to open
		cout << "Error opening the file: testdata" << endl;
		return 0;
	}

	infile.getline(arr1,512); //Get the first 2 lines of the test data
	infile.getline(arr2,512);

	while(!infile.eof()){ //While the file is not end of file
		char tempArr[513] = {}; //temp array declaration

		char s[2] = {'S','\0'}; //char arrays for S,U,Z
		char u[2] = {'U','\0'};
		char z[2] = {'Z','\0'};

		char letters1[4] = {}; //Put in S,U,Z into these for Add Array
		char letters2[4] = {}; //				""			 Sub Array

		int length = strlen(arr1)-1; //length of the array
		
		int carry = 0; //carry and carry and parries declarations
		int carryIn =0;
		int parry1 = 0;
		int parry2 = 0;
		int parry3 = 0;
		
		carryIn = addBinary(arr1, arr2, tempArr, length, carry, parry1, parry2, parry3); //Add the binary numbers and have the carryIn set to the return value
			
		if(carryIn != carry) //If carryIn does not equal carry, then it is Signed overflow
			strcat(letters1,s);
		else
			strcat(letters1," ");	

		if(carry == 1) //If carry equals 1, then it is Unsigned overflow (For addition)
			strcat(letters1,u);
		else
			strcat(letters1," ");	

		if(parry3 == 0) //If Parry3 equals 0, then Z is added to letters1
			strcat(letters1,z);
		else
			strcat(letters1," ");		
			
		parry1 = parry1 % 2; //Modulus division the parries for testing
		parry2 = parry2 % 2;
		parry3 = parry3 % 2;	

		if(parry1 == 1)
			point1 = odd;  //if Parry1 is 1, it is odd
		else
			point1 = even;	//if not, then it is even	
		if(parry2 == 1)
			point2 = odd;  //if Parry2 is 1, it is odd
		else
			point2 = even;  //if not, then it is even	
		if(parry3 == 1)
			point3 = odd;  //if Parry3 is 1, it is odd
		else
			point3 = even; //if not, then it is even	
			
		cout << setw(5) << left << "v1" << setw(5) << point1 << setw(4) << " "  << setw(6) << arr1 << endl;	//Print the line for the 2 arrays and Addition array
		cout << setw(5) << left << "v2" << setw(5) << point2 << setw(4) << " "  << setw(6) << arr2 << endl;
		cout << setw(5) << left << "sum" << setw(5) << point3 << setw(4) << letters1 << setw(6) << tempArr << endl;
		
		parry3 = 0; //Reset parry3
		carry = 1; //Make carry = 1 for twos complement
		
		flip(arr2, tempArr, length); //Flip the second array and add
		carryIn = addBinary(arr1, arr2, tempArr, length, carry, parry1, parry2, parry3); //Add the 2 arrays and store into temp array, and return the carryIn to the MSB
		
	
		if(carryIn != carry) //If  carryIn does not equal carry, then it is signed overflow
			strcat(letters2,s);
		else
			strcat(letters2," ");	
			
		if(carry == 0) //If carry equals 0, then it is unsigned overflow(subtraction)
			strcat(letters2,u);
		else
			strcat(letters2," ");

		if(parry3 == 0) //If parry3 equals 0 then put Z into letters
			strcat(letters2,z);
		else
			strcat(letters2," ");	
		
		parry3 = parry3 % 2; //mod parry 3
		
		if(parry3 == 1) //If it equals 1, then it is odd
			point3 = odd;
		else
			point3 = even; //else even
		
		cout << setw(5) << left << "diff" << setw(5) << point3 << setw(4) << letters2 <<  setw(6) << tempArr << endl << endl; //Print out subtraction

		infile.getline(arr1,512); //Read the next 2 lines of the file and put into arr1 and arr2
		infile.getline(arr2,512);
	}
	return 0;
}

/*******************************************************************************************
* Name: addBinary
* Function: Adds 2 binary numbers together
* @Params:  char* x, first char array 
*			char* y, second char array		
*			char* tempArr, temporary char array to store addition
* 			int length, the length of the array
* 			int& carry, a reference to the carryOut
*			int& p1, p2 ,p3 - Intergers to count the char arrays calues for parries later
* Return: integer, the carryIn for the MSB 
********************************************************************************************/

int addBinary(char* x,char* y,char* tempArr,int length, int& carry,int& p1,int& p2, int& p3){
	int carryIn = 0;
	for(int i = length; i >= 0; i--){ //For the length of the array
		if(i == 0)
			carryIn = carry; //At the last loop, set the carry to the carryIn of the MSB
		if((x[i] == '0') && (y[i] == '0') && (carry == 0)){ //Product is 0
			tempArr[i] = '0'; //Add 0 to the index of i in tempArr
			carry = 0;
		}
		else if((x[i] == '1') && (y[i] == '0') && (carry == 0)){ //Product is 1
			p1++; //Add 1 to the parry
			p3++;
			tempArr[i] = '1';  //Add 1 to the index of i in tempArr
			carry = 0;
		}
		else if((x[i] == '0') && (y[i] == '0') && (carry == 1)){ //Product is 1
			p3++; //Add 1 to the parry
			tempArr[i] = '1';  //Add 1 to the index of i in tempArr
			carry = 0;
		}
		else if((x[i] == '0') && (y[i] == '1') && (carry == 0)){ //Product is 1
			p2++; //Add 1 to the parry
			p3++;
			tempArr[i] = '1';  //Add 1 to the index of i in tempArr
			carry = 0;
		}
			else if((x[i] == '1') && (y[i] == '0') && (carry == 1)){ //Product is 2
			p1++; //Add 1 to the parry
			tempArr[i] = '0';  //Add 0 to the index of i in tempArr
			carry = 1; 
		}
		else if((x[i] == '0') && (y[i] == '1') && (carry == 1)){ //Product is 2
			p2++;
			tempArr[i] = '0';  //Add 0 to the index of i in tempArr
			carry = 1;
		}
		else if((x[i] == '1') && (y[i] == '1') && (carry == 0)){ //Product is 2
			p2++; //Add 1 to the parry
			p1++;
			tempArr[i] = '0';  //Add 0 to the index of i in tempArr
			carry = 1;
		}
			else if((x[i] == '1') && (y[i] == '1') && (carry == 1)){ //Product is 3
			p3++; //Add 1 to the parry
			p2++;
			p1++;
			tempArr[i] = '1';  //Add 1 to the index of i in tempArr
			carry = 1;
		}
		else
			cout << "Something messed up" << endl;
	}
	return carryIn;
}

/*******************************************************************************************
* Name: addBinary
* Function: Adds 2 binary numbers together
* @Params:  char* x, first char array 
*			char* tempArr char array
* 			int length, length or array
* Return: void, nothing
********************************************************************************************/

void flip(char* x, char* tempArr, int length){ //For the length of the array
	for( int i = length; i >= 0; i--){
		if(x[i] == '1') //If it equals '1', flip the digit
			tempArr[i] = '0'; 
		else
			tempArr[i] = '1'; //Else its a 0, so flip it to 1
	}
	strcpy(x, tempArr); //Copy tempArr to x
}
