extends Node

#CREATE YOUR OWN FUNCTIONS HERE!!!!

func exp_for_lv(current_lv) -> int:
	match(current_lv):
		1:
			return 10
		2:
			return 30
		3:
			return 70
		4:
			return 120
		5:
			return 200
		6:
			return 300
		7:
			return 500
		8:
			return 800
		9:
			return 1200
		10:
			return 1700
		11:
			return 2500
		12:
			return 3500
		13:
			return 5000
		14:
			return 7000
		15:
			return 10000
		16:
			return 15000
		17:
			return 25000
		18:
			return 50000
		19:
			return 99999
	return 0
