using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.WebPages;
using DPMSapi.Models;

namespace apiDPMS.Controllers
{
    public class earningController : ApiController
    {
        // if(totalbamount==null)
        //DateTime sdate = DateTime.Parse(startdate);
        //DateTime edate = DateTime.Parse(enddate);
        //var data = db.bookings.FirstOrDefault();
        //if(data!=null)
        //{
        //   foreach(var item in data)
        //    {

        //    }
        //}
        //int countbooking=  db.bookings.Where(b => DateTime.Parse(b.requestdate).Date >= sdate.Date || DateTime.Parse(b.requestdate).Date <= edate.Date && b.status=="approved"&&b.gid==id).Count();
        //var totalbamount=db.bookings.Where(book=> DateTime.Parse(book.requestdate).Date>= sdate || DateTime.Parse(book.requestdate).Date <= edate.Date && book.status == "approved" && book.gid == id).Select(book=>book.amount).Sum();
        // if(totalbamount==null)
        //  {
        //      totalbamount = 0;
        //  }
        //int countmember = db.memberships.Where(m => DateTime.Parse(m.requestdate) >=sdate || DateTime.Parse(m.requestdate) <= edate && m.status == "approved" && m.gid == id).Count();
        //var totalearning = db.memberships.Where(me => DateTime.Parse(me.requestdate)>= sdate || DateTime.Parse(me.requestdate)<=edate && me.status == "approved").Select(me => me.amount).Sum();
        //  if (totalearning == null)
        //  {
        //      totalearning = 0;
        //  }
        //    return Request.CreateResponse(HttpStatusCode.OK,"Total Bookings="+countbooking+" Total Booking Amount=  "+totalbamount+" Total Member Added "+countmember+" Total Earning "+totalearning);

        playgroundEntities4 db = new playgroundEntities4();
        //[HttpGet]
        //public HttpResponseMessage ViewEarnings(int id,DateTime startdate,DateTime enddate)
        //{
        //    try
        //    {


        //        int countbooking = db.bookings.Where(b => b.gid == id&&b.matchdate>=startdate&&b.matchdate<=enddate&&b.status== "Approved").Count();
        //        var totalamount=db.bookings.Where(b => b.gid == id && b.matchdate >= startdate && b.matchdate <= enddate && b.status == "Approved").Select(book => book.amount).Sum();
        //        int countmember = db.memberships.Where(m => m.gid == id&&m.joindate>=startdate&&m.joindate<=enddate&&m.status=="Approved").Count();
        //        var totalmembershipearning = db.memberships.Where(m => m.gid == id && m.joindate >= startdate && m.joindate <= enddate && m.status == "Approved").Select(book => book.amount).Sum();
        //        earning e = new earning();
        //        e.totalbookings = countbooking;
        //        if(totalamount!=null)
        //        {
        //            e.totalbookingearning = double.Parse(totalamount.ToString());
        //        }

        //        e.totalmembers = countmember;
        //        if(totalmembershipearning!=null)
        //        {
        //            e.totalmemberearning = double.Parse(totalmembershipearning.ToString());
        //        }

        //        e.totalearning = e.totalbookingearning + e.totalmemberearning;
        //          return Request.CreateResponse(HttpStatusCode.OK,e);

        //    }

        //    catch
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, "Some Thing Went Wrong");

        //    }
        //}

        [HttpGet]
        public HttpResponseMessage ViewEarnings(int id, DateTime startdate, DateTime enddate)
        {
            try
            {


                int countbooking = db.bookings.Where(b => b.gid == id && b.Fromdate >= startdate && b.Fromdate <= enddate && b.status == "Approved").Count();
                var totalamount = db.bookings.Where(b => b.gid == id && b.Fromdate >= startdate && b.Fromdate <= enddate && b.status == "Approved").Select(book => book.amount).Sum();
                int countmember = db.memberships.Where(m => m.gid == id && m.joindate >= startdate && m.joindate <= enddate && m.status == "Approved").Count();
                var totalmembershipearning = db.memberships.Where(m => m.gid == id && m.joindate >= startdate && m.joindate <= enddate && m.status == "Approved").Select(book => book.amount).Sum();
                earning e = new earning();

                e.totalbookings = countbooking;
                if (totalamount != null)
                {
                    e.totalbookingearning = double.Parse(totalamount.ToString());
                }
                else
                {
                    e.totalbookingearning = 0;
                }
                e.totalmembers = countmember;
                if (totalmembershipearning != null)
                {
                    e.totalmemberearning = double.Parse(totalmembershipearning.ToString());

                }
                else
                {
                    e.totalmemberearning = 0;
                }

                e.totalearning = e.totalbookingearning + e.totalmemberearning;
                return Request.CreateResponse(HttpStatusCode.OK, e);

            }

            catch
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, "Some Thing Went Wrong");

            }
        }
    }
}
