#!/bin/bash

# Author: Aleksandra Hein
# Created on: 30.05.2021
# Last Modified On: 07.05.2021
# Version: 1
# Description: Aplikacja pomaga zorganizować każdy dzień poprzez różne możliwości takie jak stworzenie listy zakupów, listy rzeczy do zrobienia. Pozwala również obliczyć swoje BMI, ustalić plan treningowy na dany dzień, czy też sprawdzić liczbę spalonych kalorii podczas konkretnej aktywności.

organizer="My little organizer"

yad --info --text="\n<span font='12'>This application is to help you in orgaznizing your day and don't forget about anything. Let's use it and make your daily day a little bit easier. :)</span>" \
--title="My little organizer" --width 700 --image="/home/aleksandra/Pobrane/photo.png" --text-align="center" --button=OK:0

name=$(zenity --entry --title "My little organizer" --text "Enter your name: "  --height 120)
if test -z $name 
then
    zenity --error --text "You have to enter your name."
    exit
fi

generate_panel() {
    case "$1" in
	"main" )
		info="Hello <span foreground='green'>$name</span>!! Let's plan the day.\n\n<span><i>Choose options, which are available in main menu.</i></span>\n";;
	"todolist" )
	       	info="\n To do list\n";;
	"shopping" )
		info="\nCreate your shopping list\n";;
	"fit")
		if [[ ${BMI%%.*} -eq 0 ]]; then
			info="Stay fit:\n\n BMI: $BMI\n\n <span foreground='blue'>Exercises:</span> $exercises\n"
		elif [[ ${BMI%%.*} -gt 0 && ${BMI%%.*} -le 18 ]]; then
			info="Stay fit:\n\n BMI: $BMI \n <span foreground='red'>You are underweight!</span>\n\n <span foreground='blue'>Exercises:</span> $exercises\n"
		elif [[ ${BMI%%.*} -gt 18 && ${BMI%%.*} -le 25 ]]; then
			info="Stay fit:\n\n BMI: $BMI \n <span foreground='green'>Your weight is good.</span>\n\n <span foreground='blue'>Exercises:</span> $exercises\n"
		elif [[ ${BMI%%.*} -gt 25 ]]; then
			info="Stay fit:\n\n BMI: $BMI \n <span foreground='red'>You are overweight!</span>\n\n <span foreground='blue'>Exercises:</span> $exercises\n"
		fi;;
	"dates")
		info="Save important dates";;
	*) echo "Wrong arguments!!";;
    esac
}

menu=("1.To do list" "2.Create shopping list" "3.Stay fit" "4.Important dates")
menuToDoList=("1.Add to the list" "2.Delete from the list" "3.Show the list" "4.Delete entire list.")
menuShopping=("1.Add products" "2.Remove the whole product" "3.Change the number of certain product." "4.Show the list" "5.Delete entire list.")
menuStayFit=("1.Count your BMI" "2.Choose exercises for today" "3.The number of burned calories")
i=0
nameOfProduct=()
numberOfProduct=()
price=()
sum=0
BMI=0
weight=0
arr=()
x=1
exercises="none"
index=${#nameOfProduct[@]}

while true; do
	generate_panel "main"
	options=$(zenity --list --height 360 --title="My littel organizer" --text="$info" --cancel-label "Exit" --ok-label "Choose" --column="Main menu" "${menu[@]}")
	if [[ $? -eq 1 ]]; then
	    zenity --question --text="Are you sure you want to exit?"
	    if [[ $? -eq 0 ]]; then
	    	echo "End of the day"
	    	break
	    fi
	fi

	case "$options" in
		"${menu[0]}" )
			while true; do
				generate_panel "todolist"
				optionZero=$(zenity --list --height 360 --title="To do list" --text="$info" --cancel-label "Main manu" --ok-label "Choose" --column="Menu" "${menuToDoList[@]}")
				
				if [[ $? -eq 1 ]]; then	
					break
		    		fi

				case "$optionZero" in
					"${menuToDoList[0]}" )
						howMany=$(zenity --scale --title="How many items you want to place?" --text="Number: " --min-value 0 --max-value 20 --value 2 --step 1)
						for (( y=1; y<howMany+1; y++ )); do
							arr=$(zenity --entry --text="\nEntry the activity\n" --title="Adding activities")
							echo "$arr" >> toDo.txt
						done
						zenity --info --text="Activities has been added";;
					"${menuToDoList[1]}" )	
						if [[ -e toDo.txt ]]; then
							lines=$(wc -l < toDo.txt)
							number=$(zenity --scale --text="Entry the number of activity which you want to delete" --title="The number to delete" \
								--width 100 --min-value 0 --max-value $lines --step 1)
							sed "${number}d" toDo.txt > tmp
							mv tmp toDo.txt
							zenity --info --text="Activity has been deleted"
						else
							zenity --warning --text="You haven't created the list yet."
						fi;;
					"${menuToDoList[2]}" )
						if [[ -e toDo.txt ]]; then	
							cut -f2 -d "." toDo.txt > tmp
							nl -s "." tmp > tmp1 #numerowanie linii i dodawanie kropki
							mv tmp1 toDo.txt
							rm tmp
							zenity --text-info --filename="/home/aleksandra/SO/toDo.txt"
						else
							zenity --warning --text="You haven't created the list yet."
						fi;;
					"${menuToDoList[3]}" )
						if [[ -e toDo.txt ]]; then
							rm toDo.txt
							zenity --info --text="The list has been removed"
						else
							zenity --warning --text="There is no list."
						fi;;
				esac
			done;;
		"${menu[1]}" )
			while true; do
				generate_panel "shopping"
				optionOne=$(zenity --list --height 360 --title="Shopping list" --text="$info" --cancel-label "Main menu" --ok-label "Choose" \
					--column="Menu" "${menuShopping[@]}" --width 150)
				
				if [[ $? -eq 1 ]]; then
					break
				fi

				case "$optionOne" in
					"${menuShopping[0]}" )
						index=$((${#price[@]}))
						howmany=$(zenity --scale --title="How many products to add?" --text="The number" --min-value 0 --max-value 20 value 2)
						for (( y=0; y<howmany; y++ )); do
							nameOfProduct=$(zenity --entry --title="Name of the product" --text="Entry name of the product")
							numberOfProduct[$index+$y]=$(zenity --scale --text="Number of the product" --title="The amount of product" --min-value 0 \
								--max-value 20 value 0)
							res="product: ${numberOfProduct[$index+$y]}x$nameOfProduct"
							price[$index+$y]=$(zenity --entry --title="Entry rounded price" --text="Rounded price:")
							if ! [[ ${price[$index+$y]} =~ ^[0-9]{1,4}$ ]]; then
								zenity --error --text="Wrong data!"
								#new_arr=()
								#unset numberOfProduct[$toRemove-1]
								#unset price[$toRemove-1]
								#for i in ${!numberOfProduct[@]}; do
								#	new_arr+=( "${numberOfProduct[i]}" )
								#done
								#numberOfProduct=("${new_arr[@]}")
								#unset new_array
						
								#new_arr1=()
								#for i in ${!price[@]}; do
								#	new_arr1+=( "${price[i]}" )
								#done
								#price=("${new_arr1[@]}")
								#unset new_arr1
								break
							else
								echo $res >> shop.txt
								sum=$(($sum+(${numberOfProduct[$index+$y]}*${price[$index+$y]})))
								echo "Product has been added."
							fi
						done
						if [[ -e shop.txt ]]; then
							grep "product" shop.txt > tmpfile
							mv tmpfile shop.txt
							cut -f2 -d "." shop.txt > tmp
							nl -s "." tmp > tmp1
							mv tmp1 shop.txt
							rm tmp	
							echo "   sum: $sum" >> shop.txt
						fi;;
					"${menuShopping[1]}" )
						if ! [[ -e shop.txt ]]; then
							zenity --warning --text="You haven't created the list."
							break
						fi
						toRemove=$(zenity --scale --title="Enter the number of the product which you want to remove" --text="Number" --min-value 0 \
						--max-value ${#price[@]} --step 1)
						sum=$(($sum-(${numberOfProduct[$toRemove-1]}*${price[$toRemove-1]})))
						sed "${toRemove}d" shop.txt > tmp
						mv tmp shop.txt
						grep "product" shop.txt > tmpfile
		 				mv tmpfile shop.txt
						cut -f2 -d "." shop.txt > tmp
						nl -s "." tmp > tmp1
						mv tmp1 shop.txt
						rm tmp
						echo "   sum: $sum" >> shop.txt

						new_arr=()
						unset numberOfProduct[$toRemove-1]
						unset price[$toRemove-1]
						for i in ${!numberOfProduct[@]}; do
							new_arr+=( "${numberOfProduct[i]}" )
						done
						numberOfProduct=("${new_arr[@]}")
						unset new_array
						
						new_arr1=()
						for i in ${!price[@]}; do
							new_arr1+=( "${price[i]}" )
						done
						price=("${new_arr1[@]}")

						unset new_arr1
						echo "The product has been deleted.";;
					"${menuShopping[2]}" )
						if ! [[ -e shop.txt ]]; then
							zenity --warning --text="You haven't created the list."
							break
						fi
						cat shop.txt
						toChange=$(zenity --scale --text="Entry the number of the product in which you want to change its amount" --min-value 0 --max-value ${#price[@]} \
						--step 1)
						Name=$(zenity --entry --text="Entry the name of the product")
						res="${numberOfProduct[$toChange-1]}x${Name}"

						if grep --quiet "$res" shop.txt ; then #--quiet, zeby sie nie wyswietlaly powiadomoenia ze znaleziono
							value=$(zenity --scale --text="Change from ${numberOfProduct[$toChange-1]} to:" \
							--min-value 0 --max-value 20 --value 0)	
							res1="${value}x${Name}"

							if [[ $value -lt ${numberOfProduct[$toChange-1]} ]]; then
								dif=$((${price[$toChange-1]}*(${numberOfProduct[$toChange-1]}-$value)))
								sum=$(($sum-$dif))
								sed -i -e 's/'$res'/'$res1'/g' shop.txt #podmiana danych
								grep "product" shop.txt > tmpfile
								mv tmpfile shop.txt
								cut -f2 -d "." shop.txt > tmp
								nl -s "." tmp > tmp1
								mv tmp1 shop.txt
								rm tmp	
								echo "   sum: $sum" >> shop.txt
								numberOfProduct[$toChange-1]=$(($value))
							elif [[ $value -gt ${numberOfProduct[$toChange-1]} ]]; then
								dif=$((($value-${numberOfProduct[$toChange-1]})*${price[$toChange-1]}))
								sum=$(($sum+$dif))
								numberOfProduct[$toChange-1]=$(($value))
								sed -i -e 's/'$res'/'$res1'/g' shop.txt
								grep "product" shop.txt > tmpfile
								mv tmpfile shop.txt
								cut -f2 -d "." shop.txt > tmp
								nl -s "." tmp > tmp1
								mv tmp1 shop.txt
								rm tmp	
								echo "   sum: $sum" >> shop.txt
							fi
						else
							zenity --warning --text="Wrong data"
						fi;;
					"${menuShopping[3]}" )
						if [[ -e shop.txt ]]; then
							zenity --text-info --filename="/home/aleksandra/SO/shop.txt"
						else
							zenity --error --title="Warning" --text="You haven't created your list yet!"
						fi;;
					"${menuShopping[4]}" )
						if [[ -e shop.txt ]]; then
							rm shop.txt
							sum=0
							numberOfProduct=()
							price=()
							zenity --info --text="The file has been deleted"
						else
							zenity --error --title="Warning" --text="You haven't created your list yet!"
						fi;;
				esac
			done;;
		"${menu[2]}" )
			while true; do
				
				generate_panel "fit"
				optionTwo=$(zenity --list --height 360 --title="Stay fit" --text="$info" --cancel-label "Main menu" --ok-label "Choose" --column="Menu" "${menuStayFit[@]}")
				if [[ $? -eq 1 ]]; then
					break
				fi
				case "$optionTwo" in
					"${menuStayFit[0]}" )
						height=$(zenity --entry --text="Entry your height in m" --title="height")
						if [[ $height =~ ^[1-4]{1}.[0-9]{2} ]]; then
							weight=$(zenity --scale --text "Weight: " --value 57 --step 1 --min-value 0 --max-value 200)
							BMI=`echo "scale=2;$weight/$height/$height" | bc -l`
						else
							zenity --warning --text="Wrong data"	
						fi
						;;
					"${menuStayFit[1]}" )
						exercises=$(zenity --list --checklist --height 200 --width 300 --column=" " --column="Type of training" " 10min belly training " " 10min butt exercises " \
					       	" 10min legs exercises " " 10min arms exercises " " 10min butt exercises " " 40/50min full body workout " " 40/50min training \
						for butt " " 40/50min training for the core ")
						echo "Exercises for today:$exercises" >> toDo.txt;;
					"${menuStayFit[2]}" )
						activity=$(zenity --list --radiolist --width 300 --height 300 --column=' ' --column=type TRUE Bike FALSE Aerobic FALSE Dancing FALSE Jogging \
						FALSE Basketball FALSE Football FALSE Skiing FALSE Housework)
						case "$activity" in
							"Bike" )
								time=$(zenity --scale --text="time" min-value 0 max-value 5 value 0 --title="Time in minutes")
								if [[ $weight -eq 0 ]]; then
									weight=$(zenity --scale --title="Weight" --text="Entry weight" --min-value 20 --max-value 200 --value 60)
								fi
								burned=`echo "scale=2;$weight*7.5*$time/60" | bc -l`
								zenity --info --text="You have burned $burned kcal" --width 200;;
							"Aerobic" )
								time=$(zenity --scale --text="time" min-value 0 max-value 5 value 0 --title="Time in minutes")
								if [[ $weight -eq 0 ]]; then
									weight=$(zenity --scale --title="Weight" --text="Entry weight" --min-value 20 --max-value 200 --value 60)
								fi
								burned=`echo "scale=2;$weight*7.3*$time/60" | bc -l`
								zenity --info --text="You have burned $burned kcal" --width 200;;
							"Dancing" )
								time=$(zenity --scale --text="time" min-value 0 max-value 5 value 0 --title="Time in minutes")
								if [[ $weight -eq 0 ]]; then
									weight=$(zenity --scale --title="Weight" --text="Entry weight" --min-value 20 --max-value 200 --value 60)
								fi
								burned=`echo "scale=2;$weight*7.8*$time/60" | bc -l`
								zenity --info --text="You have burned $burned kcal" --width 200;;
							"Jogging" )
								time=$(zenity --scale --text="time" min-value 0 max-value 5 value 0 --title="Time in minutes")
								if [[ $weight -eq 0 ]]; then
									weight=$(zenity --scale --title="Weight" --text="Entry weight" --min-value 20 --max-value 200 --value 60)
								fi
								burned=`echo "scale=2;$weight*7*$time/60" | bc -l`
								zenity --info --text="You have burned $burned kcal" --width 200;;

							"Basketball" )
								time=$(zenity --scale --text="time" min-value 0 max-value 5 value 0 --title="Time in minutes")
								if [[ $weight -eq 0 ]]; then
									weight=$(zenity --scale --title="Weight" --text="Entry weight" --min-value 20 --max-value 200 --value 60)
								fi
								burned=`echo "scale=2;$weight*6.5*$time/60" | bc -l`
								zenity --info --text="You have burned $burned kcal" --width 200;;

							"Football" )
								time=$(zenity --scale --text="time" min-value 0 max-value 5 value 0 --title="Time in minutes")
								if [[ $weight -eq 0 ]]; then
									weight=$(zenity --scale --title="Weight" --text="Entry weight" --min-value 20 --max-value 200 --value 60)
								fi
								burned=`echo "scale=2;$weight*8*$time/60" | bc -l`
								zenity --info --text="You have burned $burned kcal" --width 200;;

							"Skiing" )
								time=$(zenity --scale --text="time" min-value 0 max-value 5 value 0 --title="Time in minutes")
								if [[ $weight -eq 0 ]]; then
									weight=$(zenity --scale --title="Weight" --text="Entry weight" --min-value 20 --max-value 200 --value 60)
								fi
								burned=`echo "scale=2;$weight*7*$time/60" | bc -l`
								zenity --info --text="You have burned $burned kcal" --width 200;;

							"Housework" )
								time=$(zenity --scale --text="time" min-value 0 max-value 5 value 0 --title="Time in minutes")
								if [[ $weight -eq 0 ]]; then
									weight=$(zenity --scale --title="Weight" --text="Entry weight" --min-value 20 --max-value 200 --value 60)
								fi
								burned=`echo "scale=2;$weight*3.3*$time/60" | bc -l`
								zenity --info --text="You have burned $burned kcal" --width 200;;
						esac;;
				esac
			done;;
		"${menu[3]}" )
			dates=$(zenity --forms --title="Add event" --text="Enter infomrations about the event." --separator=", " --add-entry "Description:" --add-entry "Where" \
			--add-calendar "When")
			echo "Event | place | date: $dates" >> wydarzenia.txt
			echo "Wydarzenie zapisano w pliku wydarzenia.txt";;

	esac
done



