# OnMyFeet

OnMyFeet is an iPhone app that help people recover from injury and regain their confidence

● It enhances patients’ engagement to improve their motivation and effort

● Its main features including the guided-goal setting interviews and frequent self-reporting feedback can improve patients’ rehab participation

● The functions of activity measurement and intensity tracking through wearable can help therapists monitor the progress and further give
instructions


##Functionality
###Log In
![alt tag](https://raw.githubusercontent.com/XiongbinZhao/OnMyFeet/master/OnMyFeet_NoLogIn/login.png)

This part implements the OAuth 2.0 framework for authorizing our app to access data from the Fitbit API. The access token gained through the framework will be stored and further used to make HTTP request to the API, while the refresh token can be used to obtain a new access token when the current one expires without having to re-prompt the user.

###Menu
![alt tag](https://raw.githubusercontent.com/XiongbinZhao/OnMyFeet/master/OnMyFeet_NoLogIn/menu.png)

This part shows the menu of the app. The whole app can be divided into four parts including setting personalized goals, monitoring activity progress acquired from Fitbit, checking in through finishing questionnaires as well as taking actions to further complete the rehabilitation treatment.

###Goal Setting Module
![alt tag](https://raw.githubusercontent.com/XiongbinZhao/OnMyFeet/master/OnMyFeet_NoLogIn/goalsetting.png)

The goals setting module allows patients to set their personalized goals, choose activities for achieving these goals and further record their performance on completing these activities.

![alt tag](https://raw.githubusercontent.com/XiongbinZhao/OnMyFeet/master/OnMyFeet_NoLogIn/goalchecking.png)

After setting goals, the patient can now set specific activities for each goal. When clicking on certain goal cell, the patient can view the activities along with the latest completing statues of these activities. The patient can add more activities through clicking on the “Add” button, and the activity list will appear for patients to choose more activities.

###Progress Monitoring Module
![alt tag](https://raw.githubusercontent.com/XiongbinZhao/OnMyFeet/master/OnMyFeet_NoLogIn/progressMonitor.png)
This part shows the activity data fetched from Fitbit API, including walking steps, moving distance, sleep time, and activity intensity. These data can be used to supervise the active status of our patients. Users can have access to all the activity data from their registration date for Fitbit to the current data.

###Check In Module
![alt tag](https://raw.githubusercontent.com/XiongbinZhao/OnMyFeet/master/OnMyFeet_NoLogIn/checkin.png)
The Check In module provide sets of questionnaires for patients. Patients can finish the questionnaire and then send to the server. Hence, therapists can view their patient’s feedback from the web portal and then evaluate patient’s status during the therapy.

###Taking Action Module
![alt tag](https://raw.githubusercontent.com/XiongbinZhao/OnMyFeet/master/OnMyFeet_NoLogIn/action.png)

In this module, user can do some relaxation activities or set alarm on the wearable to remind them of doing exercises or waking them up.

The relaxation activities are not currently provided in OnMyFeet, which means the app would redirect the user to another relaxation apps for this purpose.

###Web Portal
The Therapist’s Web Management System aims to help visualize patients’ health data and render it to therapist. Each therapist has an account and they can log in to get all the health information their patients have uploaded via mobile devices.

![alt tag](https://raw.githubusercontent.com/XiongbinZhao/OnMyFeet/master/OnMyFeet_NoLogIn/web1.png)

![alt tag](https://raw.githubusercontent.com/XiongbinZhao/OnMyFeet/master/OnMyFeet_NoLogIn/web2.png)
