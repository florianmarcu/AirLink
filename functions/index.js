require('dotenv').config()
const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

const sgMail = require("@sendgrid/mail");
const SG_API_KEY = process.env.SG_API_KEY;
const SG_TEMPLATE_EMAIL_CONFIRMATION_USER = process.env.SG_TEMPLATE_EMAIL_CONFIRMATION_USER;
sgMail.setApiKey(SG_API_KEY);

exports.sendEmailTicketConfirmationToUser = functions.firestore
    .document("users/{user}/tickets/{ticket}")
    .onCreate(async (doc, context) => {
        const data = doc.data();
        const emails = [];
        data['passenger_data'].forEach(element => {
            const email = element['email'];
            var departureTime = data['departure_time'].toDate()
            var arrivalTime = data['arrival_time'].toDate()
            /// const duration = Math.abs(departureTime - arrivalTime);
            var date_diff_indays = function(date1, date2) {
                dt1 = new Date(date1);
                dt2 = new Date(date2);
                return Math.floor((Date.UTC(dt2.getFullYear(), dt2.getMonth(), dt2.getDate()) - Date.UTC(dt1.getFullYear(), dt1.getMonth(), dt1.getDate()) ) /(1000 * 60 * 60));
            };
            var date_diff_inminutes =  function(startDate, endDate) {
                const msInMinute = 60 * 1000;
                const duration = Math.round(
                    Math.abs(endDate - startDate) / msInMinute
                );
                var res = "";
                if(duration / 60 > 1){
                    const hour = duration / 60;
                    res += hour.toString();
                    res += " ore ";
                    const mins = duration - (hour*60);
                    res += mins.toString();
                    res += " minute";
                }
                else {
                    const mins = duration - (hour*60);
                    res += mins.toString();
                    res += " minute";
                }
                return res;
            };
            var duration = date_diff_inminutes(departureTime, arrivalTime);
            var arrivalHoursAndMinutes = "";
            var departureHoursAndMinutes = "";
            var formatLuggage = function(passengerData) {
                var res = "";
                if(passengerData['luggage']['backpack'])
                    res += "Ghiozdan +";
                if(passengerData['luggage']['hand'])
                    res += "Bagaj de mână +";
                if(passengerData['luggage']['check-in'])
                    res += "Bagaj de cală";
                if(res[res.length-1] === "+")
                    res = res.substring(0, res.length - 1);
                return res;
            };
            var luggage = formatLuggage(element);
            const hourOffset = 3;
            const months = {
                0 : "Ianuarie", 1: "Februarie", 2: "Martie", 3: "Aprilie", 4: "Mai", 5: "Iunie", 6: "Iulie", 7: "August", 8: "Septembrie", 9: "Octombrie", 10: "Noiembrie", 11: "Decembrie"
            }
            var shortDate = function(date) {
                var res = "";
                res += date.getDate() + months[date.getMonth() - 1].substring(0, 3) + date.getFullYear()
                return res;
            };
            var departureDate = shortDate(data['departure_time'].toDate());
            var arrivalDate = shortDate(data['arrival_time'].toDate());
            /// Format timezone 
            var dateToLocale = function (date, tzString) {
                return new Date((typeof date === "string" ? new Date(date) : date).toLocaleString("en-US", {timeZone: tzString}));   
            }
            departureTime = dateToLocale(departureTime, "Europe/Bucharest");
            arrivalTime = dateToLocale(arrivalTime, "Europe/Bucharest");
            /// Format departure time
            if(departureTime.getHours()<10)
                departureHoursAndMinutes += "0" + (departureTime.getHours()).toString()
            else
                departureHoursAndMinutes += (departureTime.getHours()).toString()
            if(departureTime.getMinutes().toString() === "0")
                departureHoursAndMinutes += ":" + "00"
            else
                departureHoursAndMinutes += ":" + departureTime.getMinutes().toString()
            /// Format arrival time
            if(arrivalTime.getHours()<10)
                arrivalHoursAndMinutes += "0" + (arrivalTime.getHours()).toString()
            else
                arrivalHoursAndMinutes += (arrivalTime.getHours()).toString()
            if(arrivalTime.getMinutes().toString() === "0")
                arrivalHoursAndMinutes += ":" + "00"
            else
                arrivalHoursAndMinutes += ":" + arrivalTime.getMinutes().toString()
            const msg = {
                to: email,
                from: 'florian.marcu23@gmail.com',
                templateId: SG_TEMPLATE_EMAIL_CONFIRMATION_USER,
                dynamic_template_data: {
                    ticket: {
                        id: data['id'],
                        passengerName: element['name'],
                        phoneNumber: element['phone_number'],
                        companyName: data['company_name'],
                        company: data['company_name'],
                        companyAddress: data['company_address'],
                        departureLocation: data['departure_location_name'],
                        departureAddress: data['departure_location_address'],
                        arrivalLocation: data['arrival_location_name'],
                        arrivalAddress: data['arrival_location_address'],
                        departureTime: departureHoursAndMinutes,
                        arrivalTime: arrivalHoursAndMinutes,
                        tripDuration: duration,
                        class: "Economy",
                        luggage: luggage,
                        departureDate: departureDate,
                        arrivalDate: arrivalDate,
                        paymentMethod: data['payment_method'],
                        price: data['price'],
                        otherFees: 0,
                        total : data['price']
                      }
                }
            };
            console.log(msg);
            Promise.all([sgMail.send(msg)]).then(value => {
                console.log(value);
            });
        })
    });
