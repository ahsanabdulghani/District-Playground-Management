using DPMSapi.Models;
using Ninject.Activation;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Results;
using System.Web.WebPages;
using System.Xml.Linq;

namespace apiDPMS.Controllers
{
    public class apibookingController : ApiController
    {
        playgroundEntities4 db = new playgroundEntities4();
        //[HttpPost]
        //public HttpResponseMessage BookingDetails(booking b)
        //{
        //    try
        //    {
        //           // DateTime date = DateTime.ParseExact(b.matchdate.ToString(), "yyyy-MM-dd", CultureInfo.InvariantCulture);
        //        DateTime Dateofmatch = DateTime.Parse(b.matchdate.ToString());
        //        string day = Dateofmatch.DayOfWeek.ToString();
        //        var groundtiming = db.schedules.Where(s => s.gid == b.gid && s.day == day).Select(s => new { s.starttime, s.endtime }).FirstOrDefault();
        //        if (groundtiming == null)
        //        {
        //            return Request.CreateResponse(HttpStatusCode.OK, "Not Available this day");
        //        }
        //        else if (groundtiming != null)
        //        {
        //            if (b.s_time > groundtiming.endtime || b.s_time < groundtiming.starttime || b.e_time > groundtiming.endtime || b.e_time < groundtiming.starttime)
        //            {
        //                return Request.CreateResponse(HttpStatusCode.OK, "Out of Ground Timing");
        //            }

        //        }
        //        var data = db.bookings.Where(s => s.matchdate == b.matchdate && s.gid == b.gid && s.status=="Approved").Select(s => new { s.s_time, s.e_time });

        //        if (data != null)
        //        {
        //            foreach (var item in data)
        //            {
        //                if (b.s_time >= item.s_time && b.s_time <= item.e_time || b.e_time >= item.e_time && b.e_time <= item.e_time || b.e_time >= item.s_time && b.s_time <= item.e_time)
        //                {
        //                    return Request.CreateResponse(HttpStatusCode.OK, "Already Booked");
        //                }
        //            }
        //        }
        //      //  DateTime startTime = DateTime.Parse(b.matchdate.ToString() + " " + b.s_time.ToString());
        //      //  DateTime endTime = DateTime.Parse(b.matchdate.ToString() + " " + b.e_time.ToString());

        //        TimeSpan timeDifference = TimeSpan.Parse(b.e_time.ToString()) - TimeSpan.Parse(b.s_time.ToString()); // Get the time difference               
        //        double totalHours = timeDifference.TotalHours; // Get the total number of hours in the time difference
        //        double hours = totalHours;
        //        int wholeHours = (int)hours;
        //        int minutes = (int)((hours - wholeHours) * 60);
        //        // Display the result
        //        string result = wholeHours.ToString() + " hours and " + minutes.ToString() + " minutes";
        //       // string outputDate = date.ToString("MM/dd/yyyy");
        //        var fee = db.schedules.Where(s => s.gid == b.gid && s.day == day).Select(s => new { s.fee }).FirstOrDefault();
        //        double disc = 0;
        //        double totalfee = 0;
        //        double feeperhour = 0;
        //        if (fee != null && double.TryParse(fee.fee.ToString(), out double feeValue))
        //        {
        //            feeperhour = feeValue;
        //            totalfee = feeValue * totalHours;
        //        }
        //        var member = db.memberships.Where(s => s.gid == b.gid && s.cid == b.cid).FirstOrDefault();
        //        if (member != null)
        //        {
        //            var membershipdiscount = db.grounds.Where(g => g.gid == b.gid).Select(d => new { d.disc }).FirstOrDefault();
        //            if (membershipdiscount != null && double.TryParse(membershipdiscount.disc.ToString(), out double discper))
        //            {
        //                disc = disc + discper;
        //            }
        //        }
        //        double discount = totalfee * (disc / 100);
        //        double Totalamount = totalfee - discount;
        //        booking bd = new booking();
        //        bd.feeperhr = feeperhour;
        //        bd.hours = result;
        //        bd.totalfee = totalfee;
        //        bd.discount = discount;
        //        bd.TotalAmount = Totalamount;
        //        bd.s_time = b.s_time;
        //        bd.e_time = b.e_time;
        //        bd.matchdate = b.matchdate;

        //        var gdata = db.grounds.Where(g => g.gid == b.gid).Select(s => new { s.gname, s.city, s.area, s.gid }).FirstOrDefault();
        //        if (gdata != null)
        //        {
        //            bd.gid = gdata.gid;
        //            bd.gname = gdata.gname;
        //            bd.city = gdata.city;
        //            bd.area = gdata.area;
        //        }
        //        return Request.CreateResponse(HttpStatusCode.OK, bd);
        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }

        //}
        /*  --------------------- */
        [HttpPost]
        public HttpResponseMessage BookingDetails(booking b)
        {
            try
            {
                DateTime Dateofmatch = DateTime.Parse(b.matchdate.ToString());
                string day = Dateofmatch.DayOfWeek.ToString();
                var groundtiming = db.schedules.Where(s => s.gid == b.gid && s.day == day).Select(s => new { s.starttime, s.endtime }).FirstOrDefault();
                if (groundtiming == null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, "Not Available this day");
                }
                else if (groundtiming != null)
                {
                    if (b.s_time > groundtiming.endtime || b.s_time < groundtiming.starttime || b.e_time > groundtiming.endtime || b.e_time < groundtiming.starttime)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, "Out of Ground Timing");
                    }
                }

                var data = db.bookings.Where(s => s.matchdate == b.matchdate && s.gid == b.gid && s.status == "Approved").Select(s => new { s.s_time, s.e_time });
                if (data != null)
                {
                    foreach (var item in data)
                    {
                        if (b.s_time >= item.s_time && b.s_time <= item.e_time || b.e_time >= item.e_time && b.e_time <= item.e_time || b.e_time >= item.s_time && b.s_time <= item.e_time)
                        {
                            return Request.CreateResponse(HttpStatusCode.OK, "Already Booked");
                        }
                    }
                }

                TimeSpan timeDifference = TimeSpan.Parse(b.e_time.ToString()) - TimeSpan.Parse(b.s_time.ToString()); // Get the time difference
                double totalHours = timeDifference.TotalHours; // Get the total number of hours in the time difference
                double hours = totalHours;
                int wholeHours = (int)hours;
                int minutes = (int)((hours - wholeHours) * 60);
                // Display the result
                string result = wholeHours.ToString() + " hours and " + minutes.ToString() + " minutes";

                var fee = db.schedules.Where(s => s.gid == b.gid && s.day == day).Select(s => new { s.fee }).FirstOrDefault();
                double disc = 0;
                double totalfee = 0;
                double feeperhour = 0;
                if (fee != null && double.TryParse(fee.fee.ToString(), out double feeValue))
                {
                    feeperhour = feeValue;
                    totalfee = feeValue * totalHours;
                }

                var member = db.memberships.Where(s => s.gid == b.gid && s.cid == b.cid).FirstOrDefault();
                if (member != null)
                {
                    var membershipdiscount = db.grounds.Where(g => g.gid == b.gid).Select(d => new { d.disc }).FirstOrDefault();
                    if (membershipdiscount != null && double.TryParse(membershipdiscount.disc.ToString(), out double discper))
                    {
                        disc = disc + discper;
                    }
                }

                double discount = totalfee * (disc / 100);
                double TotalAmount = totalfee - discount;
                TotalAmount = Math.Round(TotalAmount, 2); // Round TotalAmount to two decimal places

                booking bd = new booking();
                bd.feeperhr = feeperhour;
                bd.hours = result;
                bd.totalfee = totalfee;
                bd.discount = discount;
                bd.TotalAmount = TotalAmount;
                bd.s_time = b.s_time;
                bd.e_time = b.e_time;
                bd.matchdate = b.matchdate;

                var gdata = db.grounds.Where(g => g.gid == b.gid).Select(s => new { s.gname, s.city, s.area, s.gid }).FirstOrDefault();
                if (gdata != null)
                {
                    bd.gid = gdata.gid;
                    bd.gname = gdata.gname;
                    bd.city = gdata.city;
                    bd.area = gdata.area;
                }

                return Request.CreateResponse(HttpStatusCode.OK, bd);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }



        [HttpGet]
        public HttpResponseMessage Bill(int bid)
        {
            try
            {
                var bill = db.bookings.Where(x => x.id == bid).FirstOrDefault();
                if (bill != null)
                {

                    //TimeSpan timeDifference = TimeSpan.Parse(bill.e_time.ToString()) - bill.s_time;
                    TimeSpan timeDifference = TimeSpan.Parse(bill.e_time.ToString()) - TimeSpan.Parse(bill.s_time.ToString()); // Get the time difference               

                    DateTime date = DateTime.Parse(bill.matchdate.ToString());
                    var day = date.DayOfWeek.ToString();// Get the time difference               
                    double totalHours = timeDifference.TotalHours; // Get the total number of hours in the time difference
                    double hours = totalHours;
                    int wholeHours = (int)hours;
                    int minutes = (int)((hours - wholeHours) * 60);
                    // Display the result
                    string result = wholeHours.ToString() + " hours and " + minutes.ToString() + " minutes";
                    //  string outputDate = date.ToString("MM/dd/yyyy");
                    var fee = db.schedules.Where(s => s.gid == bill.gid && s.day == day).Select(s => new { s.fee }).FirstOrDefault();
                    double disc = 0;
                    double totalfee = 0;
                    double feeperhour = 0;
                    if (fee != null && double.TryParse(fee.fee.ToString(), out double feeValue))
                    {
                        feeperhour = feeValue;
                        totalfee = feeValue * totalHours;
                    }
                    var member = db.memberships.Where(s => s.gid == bill.gid && s.cid == bill.cid).FirstOrDefault();
                    if (member != null)
                    {
                        var membershipdiscount = db.grounds.Where(g => g.gid == bill.gid).Select(d => new { d.disc }).FirstOrDefault();
                        if (membershipdiscount != null && double.TryParse(membershipdiscount.disc.ToString(), out double discper))
                        {
                            disc = disc + discper;
                        }
                    }
                    double discount = totalfee * (disc / 100);
                    double Totalamount = totalfee - discount;
                    booking bd = new booking();
                    bd.feeperhr = feeperhour;
                    bd.hours = result;
                    bd.totalfee = totalfee;
                    bd.discount = discount;
                    bd.TotalAmount = Totalamount;
                    bd.s_time = bill.s_time;
                    bd.e_time = bill.e_time;
                    bd.matchdate = bill.matchdate;

                    var gdata = db.grounds.Where(g => g.gid == bill.gid).Select(s => new { s.gname, s.city, s.area, s.gid }).FirstOrDefault();
                    if (gdata != null)
                    {
                        bd.gid = gdata.gid;
                        bd.gname = gdata.gname;
                        bd.city = gdata.city;
                        bd.area = gdata.area;
                    }
                    return Request.CreateResponse(HttpStatusCode.OK, bd);
                }
                return Request.CreateResponse(HttpStatusCode.OK, "No Record Found");

            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, "Something went wrong");
            }
        }

        [HttpGet]
        public HttpResponseMessage bookinghistory(int id)
        {
            try
            {
                var q = db.grounds.Join(db.bookings, g => g.gid, book => book.gid, (g, book) => new { g = g, book = book })
                  .Where(s => s.book.cid == id /*&& s.book.status == null*/)
                  .Select(x => new {x.book.id, x.g.gname, x.book.matchdate, x.book.s_time, x.book.e_time, x.book.amount, x.book.status,x.book.c_name })
                  .ToList();
              
                return Request.CreateResponse(HttpStatusCode.OK, q);
            }
            catch(Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
           
        }
        [HttpGet]
        public HttpResponseMessage bookinghistoryranges(int id)
        {
            try
            {
                var q = db.grounds.Join(db.bookings, g => g.gid, book => book.gid, (g, book) => new { g = g, book = book })
                  .Where(s => s.book.cid == id /*&& s.book.status == null*/)
                  .Select(x => new { x.book.id, x.g.gname, x.book.Fromdate,x.book.Todate,x.book.s_time, x.book.e_time, x.book.amount, x.book.status, x.book.c_name })
                  .ToList();

                return Request.CreateResponse(HttpStatusCode.OK, q);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }

        }

        //[HttpPost]
        //public HttpResponseMessage AddBooking(booking b)
        //{
        //    try
        //    {
        //        DateTime Dateofmatch = DateTime.Parse(b.matchdate.ToString());
        //        string day = Dateofmatch.DayOfWeek.ToString();
        //        var groundtiming = db.schedules.Where(s => s.gid == b.gid && s.day == day).Select(s => new { s.starttime, s.endtime }).FirstOrDefault();
        //        if (groundtiming == null)
        //        {
        //            return Request.CreateResponse(HttpStatusCode.OK, "Not Available this day");
        //        }
        //        else if (groundtiming != null)
        //        {
        //            if (b.s_time > groundtiming.endtime || b.s_time < groundtiming.starttime || b.e_time > groundtiming.endtime || b.e_time < groundtiming.starttime)
        //            {
        //                return Request.CreateResponse(HttpStatusCode.OK, "Out of Ground Timing");

        //            }
        //        }
        //        var data = db.bookings.Where(s => s.matchdate == b.matchdate && s.gid == b.gid && s.status == "Approved").Select(s => new { s.s_time, s.e_time });

        //        if (data != null)
        //        {
        //            foreach (var item in data)
        //            {
        //                if (b.s_time >= item.s_time && b.s_time <= item.e_time || b.e_time >= item.e_time && b.e_time <= item.e_time || b.e_time >= item.s_time && b.s_time <= item.e_time)
        //                {
        //                    return Request.CreateResponse(HttpStatusCode.OK, "Already Booked");

        //                }
        //            }
        //        }

        //        TimeSpan timeDifference = TimeSpan.Parse(b.e_time.ToString()) - TimeSpan.Parse(b.s_time.ToString()); // Get the time difference               
        //        double totalHours = timeDifference.TotalHours; // Get the total number of hours in the time difference
        //        double hours = totalHours;
        //        int wholeHours = (int)hours;
        //        int minutes = (int)((hours - wholeHours) * 60);
        //        // Display the result
        //        string result = wholeHours.ToString() + " hours and " + minutes.ToString() + " minutes";
        //        // string outputDate = date.ToString("MM/dd/yyyy");
        //        var fee = db.schedules.Where(s => s.gid == b.gid && s.day == day).Select(s => new { s.fee }).FirstOrDefault();
        //        double disc = 0;
        //        double totalfee = 0;
        //        double feeperhour = 0;
        //        if (fee != null && double.TryParse(fee.fee.ToString(), out double feeValue))
        //        {
        //            feeperhour = feeValue;
        //            totalfee = feeValue * totalHours;
        //        }
        //        var user = db.appusers.Where(s => s.id == b.cid).Select(x => new { x.name }).FirstOrDefault();
        //        var memberdata = db.memberships.Where(s => s.cid == b.cid && s.gid == b.gid).FirstOrDefault();
        //        if (memberdata != null)
        //        {
        //            b.mlevel = "member";
        //        }
        //        else
        //        {
        //            b.mlevel = "non-member";
        //        }
        //        double discount = totalfee * (disc / 100);
        //        double Totalamount = totalfee - discount;
        //        b.status = "pending";
        //        b.c_name = user.name;
        //        b.requestdate = DateTime.Now.Date;
        //        // b.request_time = TimeSpan.Parse(DateTime.Now.ToString("HH:mm:ss"));
        //        b.matchdate = b.matchdate;
        //        b.amount = decimal.Parse(Totalamount.ToString());
        //        db.bookings.Add(b);
        //        db.SaveChanges();

        //        return Request.CreateResponse(HttpStatusCode.OK, "Request Submitted");


        //        //  DateTime date = DateTime.ParseExact(b.matchdate, "yyyy-MM-dd", CultureInfo.InvariantCulture);

        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        [HttpPost]
        public HttpResponseMessage AddBooking(booking b)
        {
            try
            {
                DateTime Dateofmatch = DateTime.Parse(b.matchdate.ToString());
                string day = Dateofmatch.DayOfWeek.ToString();
                var groundtiming = db.schedules.Where(s => s.gid == b.gid && s.day == day).Select(s => new { s.starttime, s.endtime }).FirstOrDefault();
                if (groundtiming == null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, "Not Available this day");
                }
                else if (groundtiming != null)
                {
                    if (b.s_time > groundtiming.endtime || b.s_time < groundtiming.starttime || b.e_time > groundtiming.endtime || b.e_time < groundtiming.starttime)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, "Out of Ground Timing");
                    }
                }

                var data = db.bookings.Where(s => s.matchdate == b.matchdate && s.gid == b.gid && s.status == "Approved").Select(s => new { s.s_time, s.e_time });

                if (data != null)
                {
                    foreach (var item in data)
                    {
                        if (b.s_time >= item.s_time && b.s_time <= item.e_time || b.e_time >= item.e_time && b.e_time <= item.e_time || b.e_time >= item.s_time && b.s_time <= item.e_time)
                        {
                            return Request.CreateResponse(HttpStatusCode.OK, "Already Booked");
                        }
                    }
                }

                TimeSpan timeDifference = TimeSpan.Parse(b.e_time.ToString()) - TimeSpan.Parse(b.s_time.ToString());
                double totalHours = timeDifference.TotalHours;
                int wholeHours = (int)totalHours;
                int minutes = (int)((totalHours - wholeHours) * 60);

                string result = wholeHours.ToString() + " hours and " + minutes.ToString() + " minutes";

                var fee = db.schedules.Where(s => s.gid == b.gid && s.day == day).Select(s => new { s.fee }).FirstOrDefault();
                double totalfee = 0;
                double feeperhour = 0;

                if (fee != null && double.TryParse(fee.fee.ToString(), out double feeValue))
                {
                    feeperhour = feeValue;
                    totalfee = feeValue * totalHours;
                }

                var user = db.appusers.Where(s => s.id == b.cid).Select(x => new { x.name }).FirstOrDefault();
                var memberdata = db.memberships.Where(s => s.cid == b.cid && s.gid == b.gid).FirstOrDefault();

                if (memberdata != null)
                {
                    b.mlevel = "member";
                }
                else
                {
                    b.mlevel = "non-member";
                }

                double disc = 0; // Assign the appropriate discount value based on your discount calculation logic
                if (memberdata != null)
                {
                    var membershipdiscount = db.grounds.Where(g => g.gid == b.gid).Select(d => new { d.disc }).FirstOrDefault();
                    if (membershipdiscount != null && double.TryParse(membershipdiscount.disc.ToString(), out double discper))
                    {
                        disc = disc + discper;
                    }
                }

                double discount = totalfee * (disc / 100);
                double TotalAmount = totalfee - discount;

                b.status = "pending";
                b.c_name = user.name;
                b.requestdate = DateTime.Now.Date;
                b.matchdate = b.matchdate;
                b.amount = decimal.Parse(TotalAmount.ToString());

                db.bookings.Add(b);
                db.SaveChanges();

                return Request.CreateResponse(HttpStatusCode.OK, "Request Submitted");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }



        //[HttpPost]
        //public HttpResponseMessage ViewPendingRequests(booking b)
        //{
        //    try
        //    {
        //        var q = db.grounds.Join(db.bookings, g => g.gid, book => book.gid, (g, book) => new { g = g, book=book })
        //            .Where(s => s.book.gid == b.gid && s.book.requestdate == b.requestdate && s.book.status == null)
        //            .Select(x => new { x.g.gname,x.book.matchdate,x.book.s_time,x.book.e_time,x.book.amount,x.book.status })
        //            .ToList();
        //        var requestlist = db.bookings.Where(s => s.gid == b.gid&&s.requestdate==b.requestdate&&s.status=="pending").ToList();
        //            return Request.CreateResponse(HttpStatusCode.OK, requestlist);
        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        [HttpGet]
        public HttpResponseMessage ViewPendingRequests(int gid, DateTime matchdate)
        {
            try
            {


                var q = db.grounds.Join(db.bookings, g => g.gid, book => book.gid, (g, book) => new { g = g, book = book })
                    .Where(s => s.book.gid == gid && s.book.matchdate == matchdate && s.book.status == "pending")
                    .Select(x => new { x.g.gname, x.book.matchdate, x.book.c_name, x.book.s_time, x.book.e_time, x.book.mlevel, x.book.amount, x.book.status, x.book.id })
                    .ToList();
                return Request.CreateResponse(HttpStatusCode.OK, q);
            }
            catch (Exception ex)
            {

                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        //[HttpGet]
        //public HttpResponseMessage ViewApprovedrequest(int gid, DateTime matchdate)
        //{
        //    try
        //    {
        //        var q = db.grounds.Join(db.bookings, g => g.gid, book => book.gid, (g, book) => new { g = g, book = book })
        //            .Where(s => s.book.gid == gid && s.book.matchdate == matchdate && s.book.status == "approved")
        //            .Select(x => new { x.g.gname, x.book.matchdate, x.book.s_time, x.book.e_time, x.book.amount, x.book.status })
        //            .ToList();
        //        return Request.CreateResponse(HttpStatusCode.OK, q);
        //    }
        //    catch (Exception ex)
        //    {


        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        [HttpGet]
        public HttpResponseMessage ViewApprovedrequest(int gid, DateTime matchdate)
        {
            try
            {
                var q = db.grounds.Join(db.bookings, g => g.gid, book => book.gid, (g, book) => new { g = g, book = book })
                    .Where(s => s.book.gid == gid && s.book.matchdate == matchdate && s.book.status == "approved")
                    .Select(x => new { x.g.gname, x.book.matchdate, x.book.c_name, x.book.s_time, x.book.e_time, x.book.mlevel, x.book.amount, x.book.status, x.book.id })
                    .ToList();
                return Request.CreateResponse(HttpStatusCode.OK, q);
            }
            catch (Exception ex)
            {

                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        //[HttpGet]
        //public HttpResponseMessage Accept(int id)
        //{
        //    try
        //    {              
        //        var data = db.bookings.Where(s => s.id == id).FirstOrDefault();
        //        if (data != null)
        //        {
        //            data.status = "approved";
        //            db.SaveChanges();
        //            return Request.CreateResponse(HttpStatusCode.OK, "Accepted");
        //        }                 
        //        return Request.CreateResponse(HttpStatusCode.OK, "No Data Found");

        //    }
        //    catch (Exception ex)
        //    {

        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        [HttpGet]
        public HttpResponseMessage Accept(int id)
        {
            try
            {
                //string dt = date.ToString("MM/dd/yyy");
                var data = db.bookings.Where(s => s.id == id).FirstOrDefault();
                if (data != null)
                {
                    data.status = "approved";
                    db.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK, "Accepted");
                }

                return Request.CreateResponse(HttpStatusCode.OK, "No Data Found");

            }
            catch (Exception ex)
            {

                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        //[HttpGet]
        //public HttpResponseMessage Remove(int id)
        //{
        //    try
        //    {

        //        var data = db.bookings.Where(s => s.id == id).FirstOrDefault();
        //        if (data != null)
        //        {
        //            db.bookings.Remove(data);
        //            db.SaveChanges();
        //            return Request.CreateResponse(HttpStatusCode.OK, "Request Remove");
        //        }
        //        return Request.CreateResponse(HttpStatusCode.OK, "No Record Found");

        //    }
        //    catch (Exception ex)
        //    {

        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        [HttpGet]
        public HttpResponseMessage Remove(int id)
        {
            try
            {
                //string dt = date.ToString("MM/dd/yyy");
                var data = db.bookings.Where(s => s.id == id).FirstOrDefault();
                if (data != null)
                {
                    db.bookings.Remove(data);
                    db.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK, "Request Remove");
                }

                return Request.CreateResponse(HttpStatusCode.OK, "No Record Found");

            }
            catch (Exception ex)
            {

                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage Billranges(int bid)
        {
            try
            {
                double totalfeebeforediscount = 0;
                var bill = db.bookings.Where(x => x.id == bid).FirstOrDefault();
                if (bill != null)
                {
                    if (bill.status == "pending")
                    {
                        // Return an empty response or a message indicating that the bill is pending
                        return Request.CreateResponse(HttpStatusCode.OK, "Bill is pending");
                    }
                    DateTime Fromdate = DateTime.Parse(bill.Fromdate.ToString());
                    DateTime Todate = DateTime.Parse(bill.Todate.ToString());
                    TimeSpan duration = Todate - Fromdate;
                    int noofdays = duration.Days + 1;
                    TimeSpan timeDifference = TimeSpan.Parse(bill.e_time.ToString()) - TimeSpan.Parse(bill.s_time.ToString()); // Get the time difference               
                    double totalHours = timeDifference.TotalHours; // Get the total number of hours in the time difference
                    double hours = totalHours;
                    int wholeHours = (int)hours;
                    int minutes = (int)((hours - wholeHours) * 60);
                    string result = wholeHours.ToString() + " hours and " + minutes.ToString() + " minutes";

                    for (DateTime date = Fromdate; date <= Todate; date = date.AddDays(1))
                    {
                        string day = date.DayOfWeek.ToString();

                        var fee = db.schedules.Where(s => s.gid == bill.gid && s.day == day).Select(s => new { s.fee }).FirstOrDefault();
                        if (fee != null && double.TryParse(fee.fee.ToString(), out double feeValue))
                        {
                            totalfeebeforediscount += feeValue * totalHours;
                        }
                    }
                    double disc = 0;
                    var user = db.appusers.Where(s => s.id == bill.cid).Select(x => new { x.name }).FirstOrDefault();
                    var memberdata = db.memberships.Where(s => s.cid == bill.cid && s.gid == bill.gid && s.status == "approved").FirstOrDefault();

                    double discount = totalfeebeforediscount * (disc / 100);
                    double Totalamount = totalfeebeforediscount - discount;

                    booking bd = new booking();
                    bd.noofdays = noofdays;
                    bd.discount = discount;
                    bd.TotalAmount = Totalamount;
                    bd.totalhours = noofdays * hours;
                    bd.s_time = bill.s_time;
                    bd.e_time = bill.e_time;
                    bd.Fromdate = Fromdate.Date;
                    bd.Todate = Todate.Date;
                    var gdata = db.grounds.Where(g => g.gid == bill.gid).Select(s => new { s.gname, s.city, s.area, s.gid }).FirstOrDefault();
                    if (gdata != null)
                    {
                        bd.gid = gdata.gid;
                        bd.gname = gdata.gname;
                        bd.city = gdata.city;
                        bd.area = gdata.area;
                        bd.c_name = user.name;
                    }
                    return Request.CreateResponse(HttpStatusCode.OK, bd);





                    return Request.CreateResponse(HttpStatusCode.OK, bd);
                }
                return Request.CreateResponse(HttpStatusCode.OK, "No Record Found");

            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, "Something went wrong");
            }
        }
        [HttpPost]
        public HttpResponseMessage BookingdetailsRanges(booking b)
        {
            try
            {
                DateTime Fromdate = new DateTime();
                DateTime Todate = new DateTime();
                double totalfeebeforediscount = 0;
                if (b.Fromdate != null)
                {
                    Fromdate = DateTime.Parse(b.Fromdate.ToString());
                }
                if (b.Todate != null)
                {
                    Todate = DateTime.Parse(b.Todate.ToString());
                }

                TimeSpan timeDifference = new TimeSpan();
                TimeSpan duration = Todate - Fromdate;
                int noofdays = duration.Days + 1;
                if (b.e_time != null && b.s_time != null)
                {
                    timeDifference = TimeSpan.Parse(b.e_time.ToString()) - TimeSpan.Parse(b.s_time.ToString()); // Get the time difference               

                }
                double totalHours = timeDifference.TotalHours; // Get the total number of hours in the time difference
                double hours = totalHours;
                int wholeHours = (int)hours;
                int minutes = (int)((hours - wholeHours) * 60);
                string result = wholeHours.ToString() + " hours and " + minutes.ToString() + " minutes";
                for (DateTime date = Fromdate; date <= Todate; date = date.AddDays(1))
                {
                    string day = date.DayOfWeek.ToString();
                    var groundtiming = db.schedules.Where(s => s.gid == b.gid && s.day == day).Select(s => new { s.starttime, s.endtime }).FirstOrDefault();
                    if (groundtiming == null)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, "Ground not available on " + day + " " + date.ToShortDateString());
                    }
                    else if (groundtiming != null)
                    {
                        if (b.s_time > groundtiming.endtime || b.s_time < groundtiming.starttime || b.e_time > groundtiming.endtime || b.e_time < groundtiming.starttime)
                        {
                            return Request.CreateResponse(HttpStatusCode.OK, "Out of Ground Timing " + day + " " + date);

                        }
                    }
                    var overlappingBookings = db.bookings
                    .Where(s => s.Fromdate <= date && s.Todate >= date && s.s_time <= b.e_time && s.e_time >= b.s_time && s.status == "Approved")
                    .ToList();
                    if (overlappingBookings.Count > 0)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, $"Ground is already booked for {date.ToShortDateString()} between {b.s_time} and {b.e_time}");
                    }
                    var fee = db.schedules.Where(s => s.gid == b.gid && s.day == day).Select(s => new { s.fee }).FirstOrDefault();
                    //  double feeperhour = 0;
                    if (fee != null && double.TryParse(fee.fee.ToString(), out double feeValue))
                    {
                        // feeperhour = feeValue;
                        totalfeebeforediscount += feeValue * totalHours;
                    }
                }
                double disc = 0;

                var user = db.appusers.Where(s => s.id == b.cid).Select(x => new { x.name }).FirstOrDefault();
                var memberdata = db.memberships.Where(s => s.cid == b.cid && s.gid == b.gid).FirstOrDefault();
                var gdata = db.grounds.Where(g => g.gid == b.gid).Select(s => new { s.gname, s.city, s.area, s.gid, s.disc }).FirstOrDefault();

                if (memberdata != null)
                {
                    if (gdata.disc != null)
                    {
                        disc = double.Parse(gdata.disc.ToString());
                    }
                    b.mlevel = "member";
                }
                else
                {
                    b.mlevel = "non-member";
                }

                b.Fromdate = Fromdate;
                b.Todate = Todate;
                b.status = "pending";
                b.c_name = user.name;
                b.requestdate = DateTime.Now.Date;
                b.noofdays = noofdays;
                b.request_time = TimeSpan.Parse(DateTime.Now.ToString("HH:mm:ss"));
                // b.fromdate = b.matchdate;

                booking bd = new booking();
                //  bd.feeperhr = feeperhour;
                bd.noofdays = noofdays;


                bd.s_time = b.s_time;
                bd.e_time = b.e_time;
                bd.Fromdate = Fromdate.Date;
                bd.Todate = Todate.Date;


                double discount = totalfeebeforediscount * (disc / 100);
                bd.discount = discount;

                double Totalamount = totalfeebeforediscount - discount;

                b.amount = decimal.Parse(Totalamount.ToString());


                bd.TotalAmount = Totalamount;
                if (gdata != null)
                {
                    bd.gid = gdata.gid;
                    bd.gname = gdata.gname;
                    bd.city = gdata.city;
                    bd.area = gdata.area;
                }
                return Request.CreateResponse(HttpStatusCode.OK, bd);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpPost]
        public HttpResponseMessage AddBookingranges(booking b)
        {
            try
            {
                double totalfeebeforediscount = 0;
                DateTime fromdate = DateTime.Parse(b.Fromdate.ToString());
                DateTime todate = DateTime.Parse(b.Todate.ToString());
                TimeSpan duration = todate - fromdate;
                int noofdays = duration.Days + 1;
                TimeSpan timeDifference = TimeSpan.Parse(b.e_time.ToString()) - TimeSpan.Parse(b.s_time.ToString()); // Get the time difference               
                double totalHours = timeDifference.TotalHours; // Get the total number of hours in the time difference
                double hours = totalHours;
                int wholeHours = (int)hours;
                int minutes = (int)((hours - wholeHours) * 60);
                string result = wholeHours.ToString() + " hours and " + minutes.ToString() + " minutes";
                for (DateTime date = fromdate; date <= todate; date = date.AddDays(1))
                {
                    string day = date.DayOfWeek.ToString();
                    var groundtiming = db.schedules.Where(s => s.gid == b.gid && s.day == day).Select(s => new { s.starttime, s.endtime }).FirstOrDefault();
                    if (groundtiming == null)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, "Ground not available on " + day + " " + date.ToShortDateString());
                    }
                    else if (groundtiming != null)
                    {
                        if (b.s_time > groundtiming.endtime || b.s_time < groundtiming.starttime || b.e_time > groundtiming.endtime || b.e_time < groundtiming.starttime)
                        {
                            return Request.CreateResponse(HttpStatusCode.OK, "Out of Ground Timing " + day + " " + date);

                        }
                    }
                    var overlappingBookings = db.bookings
                    .Where(s => s.Fromdate <= date && s.Todate >= date && s.s_time <= b.e_time && s.e_time >= b.s_time && s.status == "Approved")
                    .ToList();
                    if (overlappingBookings.Count > 0)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, $"Ground is already booked for {date.ToShortDateString()} between {b.s_time} and {b.e_time}");
                    }
                    var fee = db.schedules.Where(s => s.gid == b.gid && s.day == day).Select(s => new { s.fee }).FirstOrDefault();
                    //  double feeperhour = 0;
                    if (fee != null && double.TryParse(fee.fee.ToString(), out double feeValue))
                    {
                        // feeperhour = feeValue;
                        totalfeebeforediscount += feeValue * totalHours;
                    }
                }
                double disc = 0;
                var user = db.appusers.Where(s => s.id == b.cid).Select(x => new { x.name }).FirstOrDefault();
                var memberdata = db.memberships.Where(s => s.cid == b.cid && s.gid == b.gid).FirstOrDefault();
                if (memberdata != null)
                {
                    b.mlevel = "member";
                }
                else
                {
                    b.mlevel = "non-member";
                }
                double discount = totalfeebeforediscount * (disc / 100);
                double Totalamount = totalfeebeforediscount - discount;
                b.Fromdate = DateTime.Parse(fromdate.ToShortDateString());
                b.Todate = DateTime.Parse(todate.Date.ToString("yyyy-MM-dd"));
                b.status = "pending";
                b.c_name = user.name;
                b.requestdate = DateTime.Now.Date;
                b.request_time = TimeSpan.Parse(DateTime.Now.ToString("HH:mm:ss"));
                // b.fromdate = b.matchdate;
                b.amount = int.Parse(Totalamount.ToString());
                db.bookings.Add(b);
                db.SaveChanges();

                return Request.CreateResponse(HttpStatusCode.OK, "Request Submitted Successfully");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage ViewPendingRequestsRanges(int gid, DateTime date)
        {
            try
            {
                var q = db.grounds.Join(db.bookings, g => g.gid, book => book.gid, (g, book) => new { g = g, book = book })
                    .Where(s => s.book.gid == gid && (s.book.Fromdate <= date && s.book.Todate >= date) && s.book.status == "pending")
                    .Select(x => new { x.g.gname, x.book.Fromdate, x.book.Todate, x.book.s_time, x.book.e_time, x.book.amount, x.book.status, x.book.id })
                    .ToList();
                // var requestlist = db.bookings.Where(s => s.gid == b.gid && s.requestdate == b.requestdate && s.status == "pending").ToList();
                //            var requestlist = db.bookings
                //.Where(s => s.gid == b.gid &&
                //            (s.fromdate <= b.requestdate && s.todate >= b.requestdate) &&
                //            s.status == "pending").Select(x => new { x.g.gname, x.book.matchdate, x.book.s_time, x.book.e_time, x.book.amount, x.book.status })
                //.ToList();
                return Request.CreateResponse(HttpStatusCode.OK, q);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage ViewApprovedrequestranges(int gid, DateTime date)
        {
            try
            {
                var q = db.grounds.Join(db.bookings, g => g.gid, book => book.gid, (g, book) => new { g = g, book = book })
                    .Where(s => s.book.gid == gid && s.book.Fromdate == date && s.book.status == "approved")
                    .Select(x => new { x.g.gname, x.book.Fromdate, x.book.Todate, x.book.s_time, x.book.e_time, x.book.amount, x.book.status, x.book.c_name, x.book.mlevel, x.book.id })
                    .ToList();
                return Request.CreateResponse(HttpStatusCode.OK, q);
            }
            catch (Exception ex)
            {


                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
    }
}
