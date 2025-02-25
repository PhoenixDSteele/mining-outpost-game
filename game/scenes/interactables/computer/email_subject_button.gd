class_name EmailSubjectButton extends HBoxContainer

@onready var email_title: Button = $Panel2/EmailTitle

var email_information : DataBase = null

func update_info(message_data:DataBase):
	email_information = message_data
	email_title.text = email_information.message_title
