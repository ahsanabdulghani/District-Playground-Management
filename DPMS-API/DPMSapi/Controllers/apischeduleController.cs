using System;
using System.Collections.Generic;
using System.Data.Entity.Migrations;
using System.Linq;
using System.Net;
using System.Net.Http;
using DPMSapi.Models;
using System.Web.Http;

namespace apiDPMS.Controllers
{
    public class apischeduleController : ApiController
    {
        playgroundEntities4 db = new playgroundEntities4();
        //[HttpPost]
        //public HttpResponseMessage Addschedule(schedule newschedule)
        //{
        //    try
        //    {  
        //        var schedule = db.schedules.Where(s => s.day == newschedule.day&&s.gid==newschedule.gid).FirstOrDefault();
        //        if (schedule != null)
        //            return Request.CreateResponse(HttpStatusCode.OK, "Exsist");



        //        db.schedules.Add(newschedule);
        //        db.SaveChanges();
        //        return Request.CreateResponse(HttpStatusCode.OK, "Added Successfully");
        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}        
        //[HttpGet]
        //public HttpResponseMessage ViewSchedule(int id)
        //{
        //    try
        //    {
        //        var slist = db.schedules.Where(s => s.gid == id).Select(s => new { s.id, s.day, s.starttime, s.endtime, s.gid,s.fee });
        //        if (slist != null)
        //            return Request.CreateResponse(HttpStatusCode.OK, slist);
        //        return Request.CreateResponse(HttpStatusCode.OK, "No Schedule Added Yet");

        //    }
        //    catch (Exception ex)
        //    {

        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        //[HttpGet]
        //public HttpResponseMessage Update(int id)
        //{
        //    try
        //    {
        //        var data=db.schedules.Where(s=>s.id==id).Select(a=> new { a.id,a.starttime, a.endtime,a.day,a.fee, a.gid }).FirstOrDefault();               
        //        return Request.CreateResponse(HttpStatusCode.OK, data);
        //    }
        //    catch (Exception ex)

        //    {

        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }

        //}
        //[HttpPost]
        //public HttpResponseMessage Update(schedule newschedule)
        //{
        //    try
        //    {

        //      var s=db.schedules.Where(x => x.id == newschedule.id).First();
        //        s.endtime = newschedule.endtime;
        //        s.starttime=newschedule.starttime;
        //        s.fee=newschedule.fee;
        //        //db.schedules.AddOrUpdate();
        //        db.SaveChanges();
        //        return Request.CreateResponse(HttpStatusCode.OK, "Updated Successfully");
        //    }
        //    catch (Exception ex)

        //    {

        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        //[HttpGet]
        //public HttpResponseMessage Delete(int id)
        //{
        //    try
        //    {
        //        var gschedule = db.schedules.Where(s => s.id==id).FirstOrDefault();
        //        db.schedules.Remove(gschedule);
        //        db.SaveChanges();
        //        return Request.CreateResponse(HttpStatusCode.OK, "Deleted");

        //    }
        //    catch (Exception ex)
        //    {

        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}

        [HttpPost]
        public HttpResponseMessage Addschedule(schedule newschedule)
        {
            try
            {
                var schedule = db.schedules.Where(s => s.day == newschedule.day && s.gid == newschedule.gid).FirstOrDefault();
                if (schedule != null)
                    return Request.CreateResponse(HttpStatusCode.OK, "Exsist");
                db.schedules.Add(newschedule);
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Added Successfully");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage ViewSchedule(int id)
        {
            try
            {
                var slist = db.schedules.Where(s => s.gid == id).Select(s => new { s.id, s.day, s.starttime, s.fee, s.endtime, s.gid });
                if (slist != null)
                    return Request.CreateResponse(HttpStatusCode.OK, slist);
                return Request.CreateResponse(HttpStatusCode.OK, "No Schedule Added Yet");

            }
            catch (Exception ex)
            {

                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage Update(int id)
        {
            try
            {
                var data = db.schedules.Where(s => s.id == id).Select(a => new { a.id, a.starttime, a.endtime, a.day, a.fee, a.gid });

                return Request.CreateResponse(HttpStatusCode.OK, data);
            }
            catch (Exception ex)

            {

                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }

        }
        [HttpPost]
        public HttpResponseMessage Update(schedule newschedule)
        {
            try
            {

                var s = db.schedules.Where(x => x.id == newschedule.id).First();

                s.endtime = newschedule.endtime;
                s.starttime = newschedule.starttime;
                s.fee = newschedule.fee;
                //db.schedules.AddOrUpdate();
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Updated Successfully");
            }
            catch (Exception ex)

            {

                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage Delete(int id)
        {
            try
            {
                var gschedule = db.schedules.Where(s => s.id == id).FirstOrDefault();
                db.schedules.Remove(gschedule);
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Deleted");

            }
            catch (Exception ex)
            {

                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
    }
}
