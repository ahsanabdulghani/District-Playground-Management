using System;
using System.Collections.Generic;
using System.Data.Entity.Migrations;
using System.Data.Entity.Validation;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using DPMSapi.Models;

namespace apiDPMS.Controllers
{
    public class apimembershipController : ApiController
    {
        playgroundEntities4 db = new playgroundEntities4();
        //[HttpGet]
        //public HttpResponseMessage AcceptRequest(int mid)
        //{
        //    try
        //    {
        //        var data = db.memberships.Where(s => s.id == mid).FirstOrDefault();
        //        if(data!=null)
        //        {
        //            int duration = int.Parse(data.duration.Split(' ')[0]);
        //            DateTime startdt = DateTime.Now.Date;
        //          //  startdt.AddMonths(2);


        //            DateTime enddt = startdt.AddMonths(duration);
        //            data.status = "approved";
        //            data.requestdate = startdt;
        //            data.joindate = DateTime.Now.Date;
        //            data.enddate = enddt;
        //            db.SaveChanges();
        //            return Request.CreateResponse(HttpStatusCode.OK,"Accepted");
        //        }
        //        return Request.CreateResponse(HttpStatusCode.OK, "Invalid member id");
        //    }
        //    catch(Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        //[HttpGet]
        //public HttpResponseMessage RemoveRequest(int mid)
        //{
        //    try
        //    {
        //        var data = db.memberships.Where(s => s.id == mid).FirstOrDefault();
        //        if (data != null)
        //        {
        //            data.status = "removed";
        //            db.SaveChanges();
        //            return Request.CreateResponse(HttpStatusCode.OK, "Removed");
        //        }
        //        else
        //        {
        //            return Request.CreateResponse(HttpStatusCode.OK, "Invalid member id");
        //        }
        //    }
        //    catch(Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }

        //}
        //[HttpGet]
        //public HttpResponseMessage AddRequest()
        //{
        //    try
        //    {
        //        HttpRequest request = HttpContext.Current.Request;
        //        DateTime dt = DateTime.Now.Date;
        //        membership m = new membership();
        //        m.gid = int.Parse(request["gid"]);
        //        m.cid = int.Parse(request["cid"]);
        //        m.duration = request["duration"];
        //        m.requestdate = dt;
        //        m.amount = int.Parse(request["amount"]);
        //        db.memberships.AddOrUpdate(m);
        //        db.SaveChanges();
        //        return Request.CreateResponse(HttpStatusCode.OK, "Added");
        //    }
        //    catch(Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        //[HttpGet]
        //public HttpResponseMessage Getmembershipdetails(int gid)
        //{
        //    try
        //    {
        //       var data= db.grounds.Where(g => g.gid == gid).Select(g => new {g.gid,g.mfee, g.m_duration, g.disc }).FirstOrDefault();
        //        return Request.CreateResponse(HttpStatusCode.OK, data);
        //    }
        //    catch(Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex);
        //    }
        //}
        //[HttpGet]
        //public HttpResponseMessage Viewpendingrequest(int gid,DateTime requestdate)
        //{
        //    try
        //    {         
        //        var q = db.memberships.Join(db.grounds, m => m.gid, g => g.gid, (m, g) => new { g = g, m = m }).Join(db.appusers,cm=>cm.m.cid,u=>u.id,(cm,u)=> new {cm,u}).Where(ground => ground.cm.g.gid == gid && ground.cm.m.requestdate == requestdate && ground.cm.m.status == "pending").Select(x=> new {x.cm.g.gname,x.u.name,x.cm.m.requestdate,x.cm.m.amount,x.cm.m.status}).ToList();
        //            return Request.CreateResponse(HttpStatusCode.OK, q);
        //    }
        //    catch (Exception ex)
        //    {

        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        //[HttpGet]
        //public HttpResponseMessage Viewmembers(int gid,DateTime joindate)
        //{
        //    try
        //    {
        //        var q = db.memberships.Join(db.grounds, m => m.gid, g => g.gid, (m, g) => new { g = g, m = m }).Join(db.appusers, cm => cm.m.cid, u => u.id, (cm, u) => new { cm, u }).Where(ground => ground.cm.g.gid == gid && ground.cm.m.status == "approved" && ground.cm.m.joindate == joindate).Select(x => new { x.cm.g.gname, x.u.name, x.cm.m.joindate
        //            , x.cm.m.duration, x.cm.m.enddate }).ToList();

        //            return Request.CreateResponse(HttpStatusCode.OK, q);
        //    }
        //    catch (Exception ex)
        //    {

        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        //[HttpPost]
        //public HttpResponseMessage addmembershipdetails(ground g)
        //{
        //    try
        //    {
        //       // HttpRequest request = HttpContext.Current.Request;
        //      //  ground g = new ground();
        //        //g.mfee = int.Parse(request["fee"]);
        //        //g.disc = int.Parse(request["discount"]);
        //        //g.m_duration = request["duration"];
        //        //g.gid = int.Parse(request["gid"]);
        //        var q = db.grounds.Where(m => m.gid == g.gid).FirstOrDefault();
        //        if(q!= null)
        //        {
        //            if (q.m_duration == null && q.mfee == null && q.disc == null)
        //            {
        //                q.m_duration = g.m_duration;
        //                q.mfee = Convert.ToInt32(g.mfee);
        //                q.disc = Convert.ToInt32(g.disc);
        //                db.SaveChanges();
        //                return Request.CreateResponse(HttpStatusCode.OK, "Added Successfully");
        //            }
        //            else
        //            {
        //                return Request.CreateResponse(HttpStatusCode.OK, "Already Added");
        //            }

        //        }
        //        return Request.CreateResponse(HttpStatusCode.OK, "invalid id");
        //    }
        //    catch (Exception ex)
        //    {

        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        //[HttpPost]
        //public HttpResponseMessage update()
        //{
        //    try
        //    {
        //        HttpRequest request = HttpContext.Current.Request;
        //        ground g = new ground();
        //        g.mfee = int.Parse(request["fee"]);
        //        g.disc = int.Parse(request["discount"]);
        //        g.m_duration = request["duration"];
        //        g.gid = int.Parse(request["gid"]);
        //        // string dt = dateTime.ToString("MM/dd/yyy");
        //        var q = db.grounds.Where(s => s.gid == g.gid).FirstOrDefault();
        //        if(q!=null)
        //        {
        //            q.m_duration = g.m_duration;
        //            q.mfee = Convert.ToInt32(g.mfee);
        //            q.disc = Convert.ToInt32(g.disc);
        //            db.SaveChanges();
        //            return Request.CreateResponse(HttpStatusCode.OK, "Updated Successfully");
        //        }
        //        return Request.CreateResponse(HttpStatusCode.OK, "Invalid id");


        //    }
        //    catch (Exception ex)
        //    {

        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        //[HttpGet]
        //public HttpResponseMessage update(int id)
        //{
        //    try
        //    {
        //        var q = db.grounds.Where(s => s.gid == id).Select(s=> new {s.gid,s.m_duration,s.mfee,s.gname,s.disc}).FirstOrDefault();
        //         return Request.CreateResponse(HttpStatusCode.OK, q);
        //    }
        //    catch (Exception ex)
        //    {

        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        //[HttpPost]
        //public HttpResponseMessage AcceptRequest(int mid)
        //{
        //    try
        //    {
        //        var data = db.memberships.Where(s => s.id == mid).FirstOrDefault();
        //        if (data != null)
        //        {
        //            int duration = int.Parse(data.duration.Split(' ')[0]);
        //            DateTime startdt = DateTime.Now.Date;
        //            DateTime enddt = startdt.AddMonths(duration);
        //            data.status = "approved";
        //            data.joindate = startdt.ToString();
        //            data.enddate = enddt.ToString();
        //            db.SaveChanges();
        //            return Request.CreateResponse(HttpStatusCode.OK, "Accepted");
        //        }
        //        return Request.CreateResponse(HttpStatusCode.OK, "Invalid member id");
        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        [HttpGet]
        public HttpResponseMessage AcceptRequest(int mid)
        {
            try
            {
                var data = db.memberships.Where(s => s.id == mid).FirstOrDefault();
                if (data != null)
                {
                    int duration = int.Parse(data.duration.Split(' ')[0]);
                    DateTime startdt = DateTime.Now.Date;
                    DateTime enddt = startdt.AddMonths(duration);
                    data.status = "approved";
                    data.joindate = startdt;
                    data.enddate = enddt;
                    db.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK, "Accepted");
                }
                return Request.CreateResponse(HttpStatusCode.OK, "Invalid member id");
            }
            catch (DbEntityValidationException ex)
            {
                var errorMessages = ex.EntityValidationErrors
                        .SelectMany(x => x.ValidationErrors)
                        .Select(x => x.ErrorMessage);
                var fullErrorMessage = string.Join("; ", errorMessages);
                var exceptionMessage = string.Concat(ex.Message, " The validation errors are: ", fullErrorMessage);
                return Request.CreateResponse(HttpStatusCode.InternalServerError, exceptionMessage);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }


        //[HttpPost]
        //public HttpResponseMessage AcceptRequest(int mid)
        //{
        //    try
        //    {
        //        var data = db.memberships.FirstOrDefault(s => s.id == mid);
        //        if (data != null)
        //        {
        //            if (int.TryParse(data.duration.Split(' ')[0], out int duration))
        //            {
        //                DateTime startDate = DateTime.Today;
        //                DateTime endDate = startDate.AddMonths(duration);
        //                data.status = "approved";
        //                data.joindate = startDate.ToString();
        //                data.enddate = endDate.ToString();
        //                db.SaveChanges();
        //                return Request.CreateResponse(HttpStatusCode.OK, "Accepted");
        //            }
        //            else
        //            {
        //                return Request.CreateResponse(HttpStatusCode.BadRequest, "Invalid duration format");
        //            }
        //        }
        //        return Request.CreateResponse(HttpStatusCode.NotFound, "Invalid member id");
        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}

        [HttpGet]
        public HttpResponseMessage RemoveRequest(int mid)
        {
            try
            {
                var data = db.memberships.Where(s => s.id == mid).FirstOrDefault();
                if (data != null)
                {
                    data.status = "removed";
                    db.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK, "Removed");
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.OK, "Invalid member id");
                }
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }

        }

     

        [HttpGet]
        public HttpResponseMessage AddRequest()
        {
            try
            {
                HttpRequest request = HttpContext.Current.Request;
                DateTime dt = DateTime.Now.Date;
                membership m = new membership();
                m.gid = int.Parse(request["gid"]);
                m.cid = int.Parse(request["cid"]);
                m.duration = request["duration"];
                m.status = "pending";
                m.requestdate = dt;
                m.amount = int.Parse(request["amount"]);
                db.memberships.AddOrUpdate(m);
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Added");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage Getmembershipdetails(int gid)
        {
            try
            {
                var data = db.grounds.Where(g => g.gid == gid).
                    Select(g => new { g.gid, g.mfee, g.m_duration, g.disc }).FirstOrDefault();
                return Request.CreateResponse(HttpStatusCode.OK, data);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex);
            }
        }

     


        [HttpGet]
        public HttpResponseMessage Viewpendingrequest(int gid, DateTime requestdate)
        {
            try
            {
                var q = db.memberships.Join(db.grounds, m => m.gid, g => g.gid, (m, g) => new { g = g, m = m }).Join(db.appusers, cm => cm.m.cid, u => u.id, (cm, u) => new { cm, u }).Where(ground => ground.cm.g.gid == gid && ground.cm.m.requestdate == requestdate && ground.cm.m.status == "pending").Select(x => new { x.cm.g.gname, x.u.name, x.cm.m.requestdate, x.cm.m.amount, x.cm.m.status, x.cm.m.id }).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, q);
            }
            catch (Exception ex)
            {

                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        //[HttpGet]
        //public HttpResponseMessage Viewpendingrequest(int gid)
        //{
        //    try
        //    {



        //        var memberships = db.memberships.Where(m => m.gid == gid).Select(m => new
        //        {
        //            m.id,
        //            m.requestdate,
        //            m.joindate,
        //            m.enddate,
        //            m.amount,
        //            m.duration,
        //            m.status,
        //            m.gid,
        //            m.cid,


        //        }).ToList();
        //        return Request.CreateResponse(HttpStatusCode.OK, memberships);

        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}


        [HttpGet]
        public HttpResponseMessage Viewmembers(int gid, DateTime joindate)
        {
            try
            {
                var q = db.memberships.Join(db.grounds, m => m.gid, g => g.gid, (m, g) => new { g = g, m = m }).Join(db.appusers, cm => cm.m.cid, u => u.id, (cm, u) => new { cm, u }).Where(ground => ground.cm.g.gid == gid && ground.cm.m.status == "approved" && ground.cm.m.joindate == joindate).Select(x => new { x.cm.g.gname, x.u.name, x.cm.m.joindate, x.cm.m.duration, x.cm.m.enddate, x.cm.m.status, x.cm.m.id }).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, q);
            }
            catch (Exception ex)
            {

                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpPost]
        public HttpResponseMessage addmembershipdetails(ground g)
        {
            try
            {
                HttpRequest request = HttpContext.Current.Request;
                //ground g = new ground();
                //g.mfee = int.Parse(request["fee"]);
                //g.disc = int.Parse(request["discount"]);
                //g.m_duration = request["duration"];
                //g.gid = int.Parse(request["gid"]);
                var q = db.grounds.Where(m => m.gid == g.gid).FirstOrDefault();
                if (q != null)
                {
                    if (q.m_duration == null && q.mfee == null && q.disc == null)
                    {
                        q.m_duration = g.m_duration;
                        q.mfee = Convert.ToInt32(g.mfee);
                        q.disc = Convert.ToInt32(g.disc);
                        db.SaveChanges();
                        return Request.CreateResponse(HttpStatusCode.OK, "Added Successfully");
                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, "Already Added");
                    }

                }
                return Request.CreateResponse(HttpStatusCode.OK, "invalid id");
            }
            catch (Exception ex)
            {

                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpPost]
        public HttpResponseMessage update(ground g)
        {
            try
            {
                HttpRequest request = HttpContext.Current.Request;
                //ground g = new ground();
                //g.mfee = int.Parse(request["fee"]);
                //g.disc = int.Parse(request["discount"]);
                //g.m_duration = request["duration"];
                //g.gid = int.Parse(request["gid"]);
                // string dt = dateTime.ToString("MM/dd/yyy");
                var q = db.grounds.Where(s => s.gid == g.gid).FirstOrDefault();
                if (q != null)
                {
                    q.m_duration = g.m_duration;
                    q.mfee = Convert.ToInt32(g.mfee);
                    q.disc = Convert.ToInt32(g.disc);
                    db.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK, "Updated Successfully");
                }
                return Request.CreateResponse(HttpStatusCode.OK, "Invalid id");


            }
            catch (Exception ex)
            {

                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage update(int id)
        {
            try
            {
                var q = db.grounds.Where(s => s.gid == id).Select(s => new { s.gid, s.m_duration, s.mfee, s.gname, s.disc }).FirstOrDefault();
                return Request.CreateResponse(HttpStatusCode.OK, q);
            }
            catch (Exception ex)
            {

                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
    }
}
