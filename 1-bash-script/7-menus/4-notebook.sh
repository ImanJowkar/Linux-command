#!/bin/bash
clear
DBNAME="Contact.db"
CREATE_TABLE='CREATE TABLE CONTACT(ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME VARCHAR(40),FAMILY VARCHAR(40),MOBILEPHONE INT,HOMEPHONE INT,MAIL VARCHAR(100),DEL INT);'




# This function is used for printing the text with color, you can use this function like below:
# print_style "This is a green text " "success";
# print_style "This is a yellow text " "warning";
# print_style "This is a light blue with a \t tab " "info";
# print_style "This is a red text with a \n new line " "danger";
# print_style "This has no color";



print_style () {

    if [ "$2" == "info" ] ; then
        COLOR="96m";
    elif [ "$2" == "success" ] ; then
        COLOR="92m";
    elif [ "$2" == "warning" ] ; then
        COLOR="93m";
    elif [ "$2" == "danger" ] ; then
        COLOR="91m";
    else #default color
        COLOR="0m";
    fi

    STARTCOLOR="\e[$COLOR";
    ENDCOLOR="\e[0m";

    printf "$STARTCOLOR%b$ENDCOLOR" "$1";
}



# This function checks the prerequists for running the application
check_preqs() {
flag=`which sqlite`
if [[ ! -e $flag ]]
then
	 print_style "You don't have sqlite installed on your system, please install it first\n\n" "warning";
	 read -n1 -p "Do you want to install it? [y,n]: " doit
	case $doit in
		y|Y) sudo apt install sqlite ;;
		n|N) print_style "\nThis app require sqlite" "danger"; exit 1 ;;
		*) print_style "\nThis app require sqlite" "danger"; exit 1 ;;
	esac
fi


if [[ ! -e $DBNAME ]]
then
	print_style "Database doesn't exist, so create it." "warning";
	echo $CREATE_TABLE | sqlite3 $DBNAME
	if [[ $? -eq 0 ]]
	then
		print_style "\nDatabase Created Successfully. \n" "success";
		sleep 5;
	fi
fi
}

datavalidationcheck () {

	NAME=`echo "${NAME,,}"`
	FAMILY=`echo "${FAMILY,,}"`
	EMAIL=`echo "${EMAIL,,}"`

	if [[ ! $NAME =~ ^[[:lower:]_][[:lower:][:digit:]_-]{2,15} ]]
	then
		data_validation_check=1
		print_style "Invalid Nmae \n " "danger";
	fi

	if [[ ! $FAMILY =~ ^[[:lower:]_][[:lower:][:digit:]_-]{2,15} ]]
	then
		data_validation_check=1
		print_style "Invalid FAMILY \n " "danger";
	fi

	if [[ ! $MOBILEPHONE =~ ^\+98[9]{1}[0-9]{9}$ ]]
	then
		data_validation_check=1
		print_style "Invalid Moblie Phone Number \n " "danger";
	fi

	if [[ ! $HOMEPHONE =~ ^\0[1-9][1-9]{1}[0-9]{8}$ ]]
	then
		data_validation_check=1
		print_style "Invalid Home Phone Number \n " "danger";
	fi

	if [[ ! $EMAIL =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]]
	then
		data_validation_check=1
		print_style "Invalid Email Address \n " "danger";
	fi


}

dataduplicationcheck () {
	record=`echo "SELECT NAME FROM CONTACT WHERE FAMILY = '$FAMILY' AND NAME = '$NAME' AND DEL = '0';" | sqlite3 $DBNAME`
	if [[ -n $record ]]
	then
		data_duplication_check=1
		print_style "This record alredy exist !!!\n" "danger";
	fi
}



insert_contact(){
	clear
	print_style "Each contact needs below requirement for create: (NAME, FAMILY, MOBILEPHONE, HOMEPHONE, EMAIL)\n\n" "info";
	echo -e '-------------------------'
	flag=true
	while [ $flag == "true" ]
	do
		data_validation_check=0
		data_duplication_check=0
		echo -e "\n"
		read -p "Enter Contact Name: " NAME
		read -p "Enter Contact FAMILY: " FAMILY
		read -p "Enter Moblie Number (+955842142548): " MOBILEPHONE
		read -p "Enter HOME Number: " HOMEPHONE
		read -p "Enter E-mail Address: " EMAIL



		datavalidationcheck
		dataduplicationcheck

		if [ $data_validation_check -eq 0 -a $data_duplication_check -eq 0 ]
		then
			rowCount=`echo "SELECT COUNT(*) FROM CONTACT;" | sqlite3 $DBNAME`
			rowCount=$((rowCount+1))
			echo "INSERT INTO CONTACT VALUES('$rowCount','$NAME','$FAMILY','$MOBILEPHONE','$HOMEPHONE','$EMAIL','0');" | sqlite3 $DBNAME
			if [[ $? -eq 0 ]]
			then
				echo "user addedd successfully.."
				sleep 0.6
			fi
		fi

		read -n1 -p "Do you want to continue? [y,n]: " doit
		case $doit in
			y|Y) continue; echo -e "\n" ;;
			n|N) flag=false; echo -e "\n" ;;
			*) flag=false; echo -e "\n" ;;
		esac


	done


}


showlist (){
	rowCount=`echo "SELECT COUNT(*) FROM CONTACT;" | sqlite3 $DBNAME`

	if [[ $rowCount -ne 0 ]]
	then
		clear
		print_style "list users: \n" "info";
		echo '--------------------------------'
		echo "SELECT ID,NAME,FAMILY,MOBILEPHONE,HOMEPHONE,MAIL FROM CONTACT WHERE DEL = '0';" | sqlite3 $DBNAME
		echo -e '-------------------------\n'
	else
		print_style "Data Base empty: \n" "info";
	fi

}

searchcontact (){

	contact_record_id=0
	print_style "Find user... \n" "info";
	read -p "Enter username: " NAME
	read -p "Enter FAMILY: " FAMILY

	record_row=`echo "SELECT ID FROM CONTACT WHERE FAMILY = '$FAMILY' AND NAME = '$NAME' AND DEL = '0';" | sqlite3 $DBNAME`


	return $record_row
}

modifycontact (){
	modify_contact_record_id=0
	print_style "You are modifing this user: \n " "info"
	echo "SELECT * FROM CONTACT WHERE ID = '$1';" | sqlite3 $DBNAME
	echo -e '--------------------\n'
	echo -e "\n"
	read -p "Enter Contact Name: " NAME
	read -p "Enter Contact FAMILY: " FAMILY
	read -p "Enter Moblie Number (+955842142548): " MOBILEPHONE
	read -p "Enter HOME Number: " HOMEPHONE
	read -p "Enter E-mail Address: " EMAIL

	data_validation_check=0
	data_duplication_check=0

	datavalidationcheck
	dataduplicationcheck

	if [ $data_validation_check -eq 0 -a $data_duplication_check -eq 0 ]
	then
			echo "UPDATE CONTACT SET NAME='$NAME', FAMILY='$FAMILY',MOBILEPHONE='$MOBILEPHONE',HOMEPHONE='$HOMEPHONE',MAIL='$EMAIL' WHERE ID='$1';"|sqlite3 $DBNAME

			print_style "user modified Successfully.\n" "success";

	fi
}


deleteuser () {
	echo "SELECT * FROM CONTACT WHERE ID = '$1';" | sqlite3 $DBNAME
	read -n1 -p "Do you want to delete? [y,n]: " doit
	case $doit in
		y|Y)
			echo "UPDATE CONTACT SET DEL = 1 WHERE ID='$1';" | sqlite3 $DBNAME;
			print_style "user deleted successfully\n " "success";
		;;

		n|N)
			print_style "\nuser doesn't deleted\n" "danger";
			exit 1

		;;

		*)
			print_style "\nuser doesn't deleted\n" "danger";
			exit 1
		;;
	esac

}





check_preqs


print_style "---------------------------------------\n\n" "info";
print_style "This app can create a simple notebook for you, and store the data into sqlite database. \n\n" "info";



PS3="Please Select one of above option: "
select choice in "Insert contact" "List contact" "Modify contact" "Delete contact" "Clear Screen" "Exit"
do
	case $REPLY in

		1)
			insert_contact
			;;

		2)
			showlist
			;;

		3)
			searchcontact
			returnvalue=`echo $?`
			if [[ $returnvalue -ne 0 ]]
			then
				modifycontact $returnvalue
			else
				print_style "user not found\n" "warning"
			fi
			;;

		4)
			print_style "you are deleting a user, do it carefully\n" "danger"
			searchcontact
			returnvalue=`echo $?`
			if [[ $returnvalue -ne 0 ]]
			then
				deleteuser $returnvalue
			else
				print_style "user not found\n" "warning"
			fi
			;;

		5)
			clear
			sleep 0.2
			;;

		6)
			echo "Good bye"
			sleep 1
			exit 0
			;;

		*)
			echo "Invalid Input."
			;;
		esac

done

