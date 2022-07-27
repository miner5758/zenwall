#include <iostream>
#include <fstream>
#include <vector>
#include <string>
using namespace std;

void SplitString(string s, vector<string> &v,char t){
	
	string temp = "";
	for(int i=0;i<s.length();++i){
		
		if(s[i]== t){
			v.push_back(temp);
			temp = "";
		}
		else{
			temp.push_back(s[i]);
		}
		
	}
	v.push_back(temp);
	
}
void PrintVector(vector<string> v){
	for(int i=0;i<v.size();++i)
		cout<<v[i]<<endl;
	cout<<"\n";
}

int main()
{
    string thin;
    vector<string> accounts;
	ifstream infile;
	infile.open ("C:\\Users\\paula\\Downloads\\te.txt");
        while(!infile.eof()) // To get you all the lines.
        {
	        getline(infile,thin); // Saves the line in STRING.
        }
	infile.close();
    SplitString(thin, accounts,':');
    for(int x = 0; x < accounts.size();x++){
        vector<string> t;
        SplitString(accounts[x],t,',');
        PrintVector(t);
    }
    return 0;
}