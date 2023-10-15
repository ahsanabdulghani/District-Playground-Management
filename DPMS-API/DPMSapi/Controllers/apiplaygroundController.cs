using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Data.Entity;
using System.Web;
using System.Web.Mvc;
using HttpGetAttribute = System.Web.Http.HttpGetAttribute;
using HttpPostAttribute = System.Web.Http.HttpPostAttribute;
using System.Data.SqlClient;
using System.Data.Entity.Migrations;
using System.Security.Cryptography;
using System.IO;
using Microsoft.Ajax.Utilities;
using System.Web.Helpers;
using DPMSapi.Models;
using System.Xml.Linq;
using System.Net.Http.Headers;
using System.Web.Configuration;
using System.Net.NetworkInformation;
using System.Web.Http.Results;
using Ninject.Selection;
using System.Collections;

namespace apiDPMS.Controllers
{
    public class apiplaygroundController : ApiController
    {
        static string constr = @"Data Source=DESKTOP-6N5OG2R;initial Catalog=playground;Integrated Security=True";
        SqlConnection con = new SqlConnection(constr);
        playgroundEntities4 db = new playgroundEntities4();
        //[HttpPost]       
        //public HttpResponseMessage Addground()
        //{
        //    try
        //    {
        //        HttpRequest request = HttpContext.Current.Request;
        //        ground g = new ground();
        //        var imagefile = request.Files["photo"];
        //        g.gname = request["gname"];
        //        g.city = request["city"];
        //        g.area= request["area"];
        //        g.capacity = int.Parse(request["capacity"]);
        //        g.gtype = request["gtype"];
        //        g.contact = request["contact"];
        //        g.size = request["size"];
        //        g.description = request["description"];
        //        g.address = request["address"];
        //        g.oid = int.Parse(request["ownerid"]);

        //        var groundname = db.grounds.Where(s => s.gname == g.gname).FirstOrDefault();
        //        if (groundname == null)
        //        {
        //            string fname = imagefile.FileName;
        //            string extension = imagefile.FileName.Split('.')[1];
        //            DateTime dt = DateTime.Now;
        //            String filename = fname + "_" + dt.Year + dt.Month + dt.Day + dt.Minute + dt.Second + dt.Hour + "." + extension;
        //            // filename = filename + DateTime.Now.ToShortTimeString()+"."+extension;
        //            string path = HttpContext.Current.Server.
        //                           MapPath("~/Content/Uploads/");
        //            imagefile.SaveAs(path + filename);
        //            g.image = filename;
        //            db.grounds.Add(g);
        //            db.SaveChanges();
        //            var lastinsert = db.grounds.Find(db.grounds.Max(p => p.gid));
        //            int id = lastinsert.gid;
        //            var lof = request["list[]"];
        //            if (lof!=null)
        //            {
        //                string[] values = lof.Split(',').Select(sValue => sValue.Trim()).ToArray();
        //                for (int i = 0; i < values.Length; i++)
        //                {
        //                    ground_facility gf = new ground_facility();
        //                    gf.fid = int.Parse(values[i]);
        //                    gf.gid = id;
        //                    db.ground_facility.Add(gf);
        //                    db.SaveChanges();
        //                }
        //            }
        //            return Request.CreateResponse(HttpStatusCode.OK,"Added SuccessFully");
        //        }                    
        //        return Request.CreateResponse(HttpStatusCode.OK, "Already Exsists");
        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        [HttpPost]
        public HttpResponseMessage Addground()
        {
            try
            {
                HttpRequest request = HttpContext.Current.Request;
                ground g = new ground();
                var imagefile = request.Files["image"];
                g.gname = request["gname"];
                g.city = request["city"];
                g.area = request["area"];
                g.capacity = int.Parse(request["capacity"]);
                g.gtype = request["gtype"];
                g.contact = request["contact"];
                g.size = request["size"];
                g.description = request["description"];
                g.address = request["address"];
                g.oid = int.Parse(request["ownerid"]);
                var groundname = db.grounds.Where(s => s.gname == g.gname).FirstOrDefault();
                if (groundname == null)
                {
                    string extension = imagefile.FileName.Split('.')[1];
                    DateTime dt = DateTime.Now;
                    String filename = g.gname.Trim() + "." + extension;
                    imagefile.SaveAs(HttpContext.Current.Server.
                                   MapPath("~/Content/Uploads/" + filename));
                    g.image = filename;
                    db.grounds.Add(g);
                    db.SaveChanges();

                    var lof = request["facility"];
                    if (lof != null)
                    {
                        string[] values = lof.Split(',').Select(sValue => sValue.Trim()).ToArray();
                        db.ground_facility.RemoveRange(db.ground_facility.Where(v => v.gid == g.gid));
                        for (int i = 0; i < values.Length; i++)
                        {
                            ground_facility gf = new ground_facility();
                            gf.fid = int.Parse(values[i]);
                            gf.gid = g.gid;
                            db.ground_facility.Add(gf);
                        }
                        db.SaveChanges();
                    }

                    return Request.CreateResponse(HttpStatusCode.OK, "Added SuccessFully");
                }
                return Request.CreateResponse(HttpStatusCode.OK, "Already Exsists");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.StackTrace);
            }
        }
        [HttpGet]
        public HttpResponseMessage grounddetails(int gid)
        {
            try
            {
                var glist = (from g in db.grounds
                             where g.gid == gid
                             select new
                             {
                                 g.gid,
                                 g.gname,
                                 g.city,
                                 g.area,
                                 g.capacity,
                                 g.size,
                                 g.contact,
                                 g.gtype,
                                 g.address,
                                 g.description,
                                 //g.m_duration,
                                 //g.mfee,
                                 g.image,
                                 flist = from gf in db.ground_facility
                                         join f in db.facilities on gf.fid equals f.id
                                         where gf.gid == g.gid
                                         select new
                                         {
                                             f.name,
                                         },
                                 rlist = from r in db.feedbacks join user in db.appusers on r.cid equals user.id where r.gid == gid select new { r.f_date, user.email, r.comment, r.rating },
                                 averagerating = db.feedbacks
     .Where(f => f.gid == gid)
     .Average(f => f.rating)
                             }).FirstOrDefault();
                var gDetails = (from g in db.grounds
                                where g.gid == gid
                                select new
                                {
                                    g.gid,
                                    g.gname,
                                    g.city,
                                    g.area,
                                    g.capacity,
                                    g.size,
                                    g.contact,
                                    g.gtype,
                                    g.address,
                                    g.description,
                                    g.image,
                                    flist = from gf in db.ground_facility
                                            join f in db.facilities on gf.fid equals f.id
                                            where gf.gid == g.gid
                                            select new
                                            {
                                                f.name,
                                            },
                                    rlist = from r in db.feedbacks
                                            join user in db.appusers on r.cid equals user.id
                                            where r.gid == gid
                                            select new
                                            {
                                                r.f_date,
                                                user.email,
                                                r.comment,
                                                r.rating
                                            },
                                    averagerating = db.feedbacks
                                        .Where(f => f.gid == gid)
                                        .Average(f => f.rating)
                                }).FirstOrDefault();

                return Request.CreateResponse(HttpStatusCode.OK, glist);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        //[HttpPost]
        //public HttpResponseMessage Addground(ground g)
        //{
        //    try
        //    {

        //        var groundname=db.grounds.Where(s=>s.gname==g.gname).FirstOrDefault();
        //        if(groundname==null)
        //        {
        //            db.grounds.Add(g);
        //            db.SaveChanges();

        //          var lastinsert=  db.grounds.Find(db.grounds.Max(p => p.gid));
        //           int id= lastinsert.gid;
        //            if(g.facilitieslist.Count>0)
        //            {
        //                foreach (var item in g.facilitieslist)
        //                {
        //                    if (item.isSelected == true)
        //                    {
        //                        ground_facility gfacility = new ground_facility();
        //                        gfacility.fid = item.id;
        //                        gfacility.gid = int.Parse(id.ToString());
        //                        db.ground_facility.Add(gfacility);
        //                        db.SaveChanges();
        //                    }
        //                }

        //            }
        //            return Request.CreateResponse(HttpStatusCode.OK, "Added Successfully");
        //        }
        //        else
        //        {
        //            return Request.CreateResponse(HttpStatusCode.OK, "Already Exists");
        //        }             
        //    }
        //    catch
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, "Some Thing Went Wrong");
        //    }

        //}


        //[HttpGet]
        //public HttpResponseMessage AllGrounds(int id)
        //{

        //    try
        //    {
        //        var result = from left in db.grounds
        //                     join right in db.ground_facility
        //                     on left.gid equals right.gid 
        //                     where left.oid==id
        //                     select new
        //                     {
        //                         LeftData = left.gname,
        //                         RightList =right.gid,right.fid 
        //                     };
        //        //var query = from l in db.grounds
        //        //            join r in db.ground_facility on l.gid equals r.gid into rGroup
        //        //            from r in rGroup.DefaultIfEmpty()
        //        //            join o in db.facilities on r.fid equals o.id into oGroup
        //        //            from o in oGroup.DefaultIfEmpty()
        //        //            select new
        //        //            {
        //        //                LeftData = l.gname,l.area,
        //        //                RightData = r == null ? null : r.gid,r.fid,
        //        //                OtherRightData = o == null ? null : o.name
        //        //            };

        //        //var leftTableData = from leftRecord in db.grounds
        //        //                    where leftRecord.oid == id
        //        //                    select new
        //        //                    {

        //        //                        rightTableData = from rightRecord in db.ground_facility
        //        //                                         where rightRecord.gid == leftRecord.gid

        //        //                                         select new { rightRecord.gid, rightRecord.fid,
        //        //                                             otherrightTableData = from otherright in db.facilities
        //        //                                                              where otherright.id == rightRecord.fid select new {leftRecord.gname,rightRecord.gid,rightRecord.fid,otherright.name } },

        //        //                    };
        //        var glist = from g in db.grounds
        //                            where g.oid == id
        //                            select new
        //                            {
        //                                g.gid,g.gname,g.city,
        //                               g.area,g.capacity,g.description,g.image,
        //                                flist = from gf in db.ground_facility join f in db.facilities on gf.fid equals f.id
        //                                                 where gf.gid == g.gid
        //                                                 select new { f.name }
        //                            };               
        //        //   var left = db.grounds.Where(leftRecord => leftRecord.oid == id).Select(s => new { s,db.ground_facility.Where(s.gid) });
        //        // var groundlist = db.grounds.Where(g => g.oid == id).FirstOrDefault();
        //        // var groundlist = db.grounds.Where(g => g.oid == id).Select(x => new { x.gid, x.gname, x.area, x.city, x.capacity, x.description, x.image });
        //        //var groundlist = db.grounds.Join
        //        //    (db.ground_facility, g => g.gid, g_f => g_f.gid, (g, g_f) => new { g = g, g_f = g_f })
        //        //    .Join(db.facilities, f => f.g_f.fid, fa => fa.id, (f, fa) => new { f = f, fa = fa })
        //        //    .Where(ground => ground.f.g.oid == id)
        //        //    .Select(x => new { x.f.g.gname, x.f.g.area, x.f.g_f.fid, x.fa.name }).FirstOrDefault();

        //        if (glist != null)
        //        {
        //            return Request.CreateResponse(HttpStatusCode.OK, glist);
        //        }
        //        return Request.CreateResponse(HttpStatusCode.OK, "No Record");
        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        [HttpGet]
        public HttpResponseMessage AllGrounds(int id)
        {
            try
            {
                var glist = from leftRecord in db.grounds
                            where leftRecord.oid == id
                            select new
                            {
                                leftRecord.gid,
                                leftRecord.gname,
                                leftRecord.city,
                                leftRecord.area,
                                leftRecord.capacity,
                                leftRecord.description,
                                leftRecord.image,
                                flist = from rightRecord in db.ground_facility
                                        join otherright in db.facilities on rightRecord.fid equals otherright.id
                                        where rightRecord.gid == leftRecord.gid
                                        select new { otherright.name }
                            };
                //var groundlist = db.grounds.Where(g => g.oid == id).Select(x => new { x.gid,x.gname,x.area,x.city,x.capacity,x.description });
                //var Allgroundlist = db.grounds.Join
                //    (db.ground_facility, g => g.gid, g_f => g_f.gid, (g, g_f) => new { g = g, g_f = g_f })
                //   .Join(db.facilities, f => f.g_f.fid, u => u.id, (f, u) => new { f, u })
                //    .Where(ground => ground.f.g.oid == id)
                //    .Select(x => new { x.f.g.gname, x.f.g.area,x.f.g.ground_facility });
                if (glist != null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, glist);
                }
                return Request.CreateResponse(HttpStatusCode.OK, "No Record");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);

            }
        }


        //[HttpGet]
        //public HttpResponseMessage Edit(int id)
        //{
        //    try
        //    {
        //        var ground = from leftRecord in db.grounds
        //                    where leftRecord.gid == id
        //                    select new
        //                    {
        //                        leftRecord.gid,
        //                        leftRecord.gname,
        //                        leftRecord.city,
        //                        leftRecord.area,
        //                        leftRecord.size,
        //                        leftRecord.gtype,
        //                        leftRecord.contact,
        //                        leftRecord.capacity,
        //                        leftRecord.description,
        //                        leftRecord.address,
        //                        leftRecord.image,
        //                        flist = from rightRecord in db.ground_facility
        //                                join otherright in db.facilities on rightRecord.fid equals otherright.id
        //                                where rightRecord.gid == leftRecord.gid
        //                                select new { otherright.name }
        //                    };
        //        var g = ground.FirstOrDefault();

        //        if ( g!= null)
        //        {
        //            return Request.CreateResponse(HttpStatusCode.OK, g);
        //        }
        //        return Request.CreateResponse(HttpStatusCode.OK, "No Record");

        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);

        //    }

        //}



        //[HttpGet]
        //public HttpResponseMessage Edit(int id)
        //{
        //    try
        //    {
        //        var ground = db.grounds.Where(g => g.gid == id).Select(x => new { x.gid, x.gname, x.area, x.city, x.capacity, x.description, x.gtype, x.contact, x.address, x.size, x.image });
        //        if (ground != null)
        //        {
        //            return Request.CreateResponse(HttpStatusCode.OK, ground);
        //        }
        //        return Request.CreateResponse(HttpStatusCode.OK, "No Record");

        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
         
         [HttpGet]
         public HttpResponseMessage Edit(int id)
         {
             try
             {
                 var ground = db.grounds.Where(g => g.gid == id)
                .Select(x => new
                {
                    // facilities
                    x.gid,
                    x.gname,
                    x.area,
                    x.city,
                    x.capacity,
                    x.description,
                    x.gtype,
                    x.contact,
                    x.size,
                    x.address,
                    x.image,
                   // x.oid,
                    facility = db.ground_facility.Where(S => S.gid == id).Select(v => v.fid)
                })
                .FirstOrDefault();

                 if (ground != null)
                 {
                     return Request.CreateResponse(HttpStatusCode.OK, ground);
                 }
                 return Request.CreateResponse(HttpStatusCode.OK, "No Record");
             }
             catch (Exception ex)
             {
                 return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
             }
         }
      
        //[HttpPost]
        //public HttpResponseMessage Edit()
        //{
        //    try
        //    {


        //        HttpRequest request = HttpContext.Current.Request;
        //        ground g = new ground();
        //        var imagefile = request.Files["photo"];
        //        g.gname = request["gname"];
        //        g.city = request["city"];
        //        g.area = request["area"];
        //        g.capacity = int.Parse(request["capacity"]);
        //        g.gtype = request["gtype"];
        //        g.contact = request["contact"];
        //        g.size = request["size"];
        //        g.description = request["description"];
        //        g.address = request["address"];
        //        g.oid = int.Parse(request["ownerid"]);
        //        g.gid= int.Parse(request["gid"]);
        //        var grd = db.grounds.Where(x => x.gid == g.gid).FirstOrDefault();
        //        grd.gname = g.gname;
        //        grd.city = g.city;
        //        grd.area = g.area;
        //        grd.capacity = g.capacity;
        //        grd.gtype = g.gtype;
        //        grd.contact = g.contact;
        //        grd.size = g.size;
        //        grd.description = g.description;
        //        grd.address = g.address;

        //       // var groundname = db.grounds.Where(s => s.gname == g.gname).FirstOrDefault();
        //        //if (groundname == null)
        //        //{
        //            string fname = imagefile.FileName;
        //            string extension = imagefile.FileName.Split('.')[1];
        //            DateTime dt = DateTime.Now;
        //            String filename = fname + "_" + dt.Year + dt.Month + dt.Day + dt.Minute + dt.Second + dt.Hour + "." + extension;
        //            // filename = filename + DateTime.Now.ToShortTimeString()+"."+extension;
        //            string path = HttpContext.Current.Server.
        //                           MapPath("~/Content/Uploads/");
        //            imagefile.SaveAs(path + filename);
        //            grd.image = filename;
        //          //
        //          //db.grounds.Add(g);
        //            db.SaveChanges();
        //            //var lastinsert = db.grounds.Find(db.grounds.Max(p => p.gid));
        //            //int id = lastinsert.gid;
        //            //var lof = request["list[]"];
        //            //if (lof != null)
        //            //{
        //            //    string[] values = lof.Split(',').Select(sValue => sValue.Trim()).ToArray();
        //            //    for (int i = 0; i < values.Length; i++)
        //            //    {
        //            //        ground_facility gf = new ground_facility();
        //            //        gf.fid = int.Parse(values[i]);
        //            //        gf.gid = id;
        //            //        db.ground_facility.Add(gf);
        //            //        db.SaveChanges();
        //            //    }
        //            //}
        //            return Request.CreateResponse(HttpStatusCode.OK, "Updated SuccessFully");
        //        //}
        //       // return Request.CreateResponse(HttpStatusCode.OK, "Already Exsists");
        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        [HttpPost]

        public HttpResponseMessage Edit()
        {
            //try
            //{

            //    var ground = db.grounds.Where(g => g.gid == g.gid).FirstOrDefault();
            //    if (ground != null)
            //    {
            //        db.grounds.AddOrUpdate(grd);
            //        db.SaveChanges();
            //        return Request.CreateResponse(HttpStatusCode.OK, "Updated Successfully");

            //    }
            //    return Request.CreateResponse(HttpStatusCode.OK, "No Record");

            //}
            //catch (Exception ex)
            //{
            //    return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);

            //}

            try
            {
                HttpRequest request = HttpContext.Current.Request;
                ground g = new ground();
                var imagefile = request.Files["image"];
                g.gid = int.Parse(request["gid"]);
                g.gname = request["gname"];
                g.city = request["city"];
                g.area = request["area"];
                g.capacity = int.Parse(request["capacity"]);
                g.gtype = request["gtype"];
                g.contact = request["contact"];
                g.size = request["size"];
                g.description = request["description"];
                g.address = request["address"];
                g.oid = int.Parse(request["ownerid"]);


                var ground = db.grounds.Where(s => s.gid == g.gid).FirstOrDefault();

                string extension = imagefile.FileName.Split('.')[1];
                DateTime dt = DateTime.Now;
                String filename = dt.ToFileTime() + "." + extension;
                imagefile.SaveAs(HttpContext.Current.Server.
                               MapPath("~/Content/Uploads/" + filename));
                ground.image = filename;
                ground.gname = g.gname;
                ground.area = g.area;
                ground.city = g.city;
                ground.capacity = g.capacity;
                ground.gtype = g.gtype;
                ground.address = g.address;
                ground.description = g.description;
                ground.size = g.size;
                ground.contact = g.contact;
                //ground.ground_facility = g.ground_facility;
                //ground.image = g.image;
                db.grounds.AddOrUpdate();
                db.SaveChanges();
                //var lastinsert = db.grounds.Find(db.grounds.Max(p => p.gid));
                //int id = lastinsert.gid;
                var lof = request["facility"];
                if (lof != null)
                {
                    string[] values = lof.Split(',').Select(sValue => sValue.Trim()).ToArray();
                    db.ground_facility.RemoveRange(db.ground_facility.Where(v => v.gid == g.gid));
                    for (int i = 0; i < values.Length; i++)
                    {
                        ground_facility gf = new ground_facility();
                        gf.fid = int.Parse(values[i]);
                        gf.gid = g.gid;
                        db.ground_facility.Add(gf);
                    }
                    db.SaveChanges();
                }

                return Request.CreateResponse(HttpStatusCode.OK, "Updated Successfully");



            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        //[HttpGet]
        //public HttpResponseMessage GroundList()
        //{
        //    try
        //    {
        //        var glist = from leftRecord in db.grounds

        //                    select new
        //                    {
        //                        leftRecord.gid,
        //                        leftRecord.gname,
        //                        leftRecord.city,
        //                        leftRecord.area,
        //                        leftRecord.capacity,
        //                        leftRecord.description,
        //                        leftRecord.image,
        //                        flist = from rightRecord in db.ground_facility
        //                                join otherright in db.facilities on rightRecord.fid equals otherright.id
        //                                where rightRecord.gid == leftRecord.gid
        //                                select new { otherright.name }
        //                    };
        //        return Request.CreateResponse(HttpStatusCode.OK, glist);
        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }

        //}

        
        [HttpPost]
        public HttpResponseMessage AvailableGrounds()
        {
            try
            {
                HttpRequest request = HttpContext.Current.Request;
                ground grd = new ground();


                grd.city = request["city"];
                grd.area = request["area"];
                grd.gtype = request["gtype"];
                if(request["stime"]!=null)
                {
                    grd.stime = TimeSpan.Parse(request["stime"]);
                }
                if (request["etime"] != null)
                {
                    grd.etime = TimeSpan.Parse(request["etime"]);
                }

                grd.matchdate = DateTime.Parse(request["matchdate"]);
                DateTime dateofmatch = DateTime.Parse(grd.matchdate.ToString());
                string day = dateofmatch.DayOfWeek.ToString();
                var lof = request["list[]"];
                List<int> fidlist = new List<int>();
                if (lof != null)
                {
                    string[] values = lof.Split(',').Select(sValue => sValue.Trim()).ToArray();
                    for (int i = 0; i < values.Length; i++)
                    {

                        int id = int.Parse(values[i]);
                        fidlist.Add(id);
                    }
                }
                var availableGrounds =
from g in db.grounds

where fidlist.All(fid => g.ground_facility.Any(gf => gf.fid == fid)) &&
g.city == grd.city && g.area == grd.area && g.gtype == grd.gtype &&
!db.bookings.Any(booking =>
booking.gid == g.gid &&
booking.matchdate == dateofmatch &&
booking.s_time <= grd.etime &&
booking.e_time >= grd.stime
&& booking.status == "Approved"
) &&
 db.schedules.Any(schedule =>
     schedule.gid == g.gid &&
     schedule.day == day &&
     grd.etime >= grd.stime &&
     schedule.starttime <= grd.stime &&
     schedule.endtime >= grd.stime &&
      schedule.starttime <= grd.etime &&
     schedule.endtime >= grd.etime
 )
select new
{
g.gid,
g.gname,
g.city,
g.area,
g.capacity,
g.description,
g.image,
flist = from gf in db.ground_facility
      join f in db.facilities on gf.fid equals f.id
      where gf.gid == g.gid
      select new { f.name },
averagerating = db.feedbacks
.Where(f => f.gid == g.gid)
.Average(f => f.rating)
};



                return Request.CreateResponse(HttpStatusCode.OK, availableGrounds);

            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }






        //    [HttpPost]
        //    public HttpResponseMessage AvailableGrounds()
        //    { try
        //        {
        //            HttpRequest request = HttpContext.Current.Request;
        //            ground grd = new ground();


        //            grd.city = request["city"];
        //            grd.area = request["area"];             
        //            grd.gtype = request["gtype"];
        //             grd.stime = TimeSpan.Parse(request["stime"]);            
        //            grd.matchdate= DateTime.Parse(request["matchdate"]);
        //            var lof = request["list[]"];
        //            List<int> fidlist=new List<int>();
        //            if (lof != null)
        //            {
        //                string[] values = lof.Split(',').Select(sValue => sValue.Trim()).ToArray();
        //                for (int i = 0; i < values.Length; i++)
        //                {

        //                   int id=int.Parse(values[i]);
        //                    fidlist.Add(id);  
        //                }
        //            }

        //            //             if (city != null & area == null && gtype == null && matchdate == null && stime == null && etime == null && fid == null)
        //            //             {
        //            //                 var availablegrounds =
        //            //from g in db.grounds

        //            //where
        //            // g.city == city

        //            //select new
        //            //{g.gid,g.gtype,g.gname,g.city,g.area,g.capacity,g.description,g.image,

        //            //    flist = from rightRecord in db.ground_facility
        //            //            join otherright in db.facilities on rightRecord.fid equals otherright.id
        //            //            where rightRecord.gid == g.gid
        //            //            select new { otherright.name }
        //            //};
        //            //                 return Request.CreateResponse(HttpStatusCode.OK, availablegrounds);

        //            //             }
        //            //           else  if (city == null & area == null && gtype == null && matchdate != null && stime == null && etime == null && fid == null)
        //            //             {
        //            //                 var searchbyarea =
        //            //from g in db.grounds

        //            //where
        //            // g.area == area

        //            //select new
        //            //{g.gid,g.gname,g.city,g.area,g.capacity,g.description,g.image,

        //            //    flist = from rightRecord in db.ground_facility
        //            //            join otherright in db.facilities on rightRecord.fid equals otherright.id
        //            //            where rightRecord.gid == g.gid
        //            //            select new { otherright.name }
        //            //};
        //            //                 return Request.CreateResponse(HttpStatusCode.OK, searchbyarea);

        //            //             }
        //            //             else if (city == null & area == null && gtype != null && matchdate == null && stime == null && etime == null && fid == null)
        //            //             {
        //            //                 var searchbyarea =
        //            //from g in db.grounds

        //            //where
        //            // g.gtype == gtype

        //            //select new
        //            //{
        //            //    g.gid,g.gname,g.city,g.area,g.capacity,g.description,g.image,

        //            //    flist = from rightRecord in db.ground_facility
        //            //            join otherright in db.facilities on rightRecord.fid equals otherright.id
        //            //            where rightRecord.gid == g.gid
        //            //            select new { otherright.name }
        //            //};
        //            //                 return Request.CreateResponse(HttpStatusCode.OK, searchbyarea);

        //            //             }
        //            var grounds = from g in db.grounds
        //                          join gf in db.ground_facility on g.gid equals gf.gid
        //                          where fidlist.All(f => gf.fid == f)
        //                          group g by g.gid into gGroup
        //                          where gGroup.Count() == fidlist.Count
        //                          select gGroup.FirstOrDefault();
        //            var availableGrounds1 =
        //                (from g in db.grounds
        //                 join gf in db.ground_facility on g.gid equals gf.gid
        //                 where fidlist.All(fid => db.ground_facility.Any(gf => gf.fid == fid && gf.gid == g.gid))
        //                 && g.city == grd.city && g.area == grd.area && g.gtype == grd.gtype &&
        //                     !(from b in db.bookings
        //                       where b.matchdate == grd.matchdate &&
        //                             ((grd.stime >= b.s_time && grd.stime < b.e_time) || (grd.etime >= b.s_time && grd.etime < b.e_time))
        //                       select b.gid)
        //                     .Contains(g.gid)
        //                 select new
        //                 {
        //                     g.gid,
        //                     g.gname,
        //                     g.city,
        //                     g.area,
        //                     g.capacity,
        //                     g.description,
        //                     g.image,
        //                     flist = (from gf in db.ground_facility
        //                              join f in db.facilities on gf.fid equals f.id
        //                              where gf.gid == g.gid
        //                              select new { f.name }).Distinct()
        //                 }).Distinct();
        //            var query = from g in db.grounds
        //                        where fidlist.All(fid => g.ground_facility.Any(gf => gf.fid == fid))
        //                        select new
        //                        {
        //                            g.gid,
        //                            g.gname
        //                        };


        //            var availableGrounds =
        // from g in db.grounds

        // where fidlist.All(fid => g.ground_facility.Any(gf => gf.fid == fid))
        //&& g.city == grd.city && g.area == grd.area && g.gtype == grd.gtype &&
        //      !(from b in db.bookings
        //        where b.matchdate == grd.matchdate &&
        //              ((grd.stime >= b.s_time && grd.stime < b.e_time) || (grd.etime >= b.s_time && grd.etime < b.e_time))
        //        select b.gid)
        //      .Contains(g.gid)
        //  select new
        //  {
        //      g.gid,
        //      g.gname,
        //      g.city,
        //      g.area,
        //      g.capacity,
        //      g.description,
        //      g.image,
        //      flist = from gf in db.ground_facility
        //              join f in db.facilities on gf.fid equals f.id
        //              where gf.gid == g.gid
        //              select new { f.name }
        //  };

        //           // var result = availableGrounds.ToList();

        //            //

        //            return Request.CreateResponse(HttpStatusCode.OK, availableGrounds);
        //            }






        //        catch (Exception ex)
        //        {
        //            return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //        }

        //    }
        //[HttpGet]
        //public HttpResponseMessage GroundNameList(int id)
        //{
        //    try
        //    {
        //        var glist = db.grounds.Where(x => x.oid == id).Select(s => new { s.gid, s.gname });
        //        return Request.CreateResponse(HttpStatusCode.OK, glist);
        //    }
        //    catch(Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }

        //}
        [HttpGet]
        public HttpResponseMessage GroundNameList(int id)
        {

            //List<ground> groundlist = new List<ground>();


            try
            {

                var groundlist = db.grounds
                    .Where(g => g.oid == id)
                    .Select(g => new { g.gid, g.gname })
                    .ToList();

                if (groundlist.Count > 0)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, groundlist);
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.OK, "No Records");
                }
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }


        }

        //public HttpResponseMessage GroundNameList(int id)
        //{
        //    List<ground> groundlist = new List<ground>();
        //    try
        //    {
        //        con.Open();
        //        string query = "Select gid,gname from ground where oid='" + id + "'";
        //        SqlCommand cmd = new SqlCommand(query, con);
        //        SqlDataReader sdr = cmd.ExecuteReader();
        //        while (sdr.Read())
        //        {
        //            ground g = new ground();
        //            g.gid = int.Parse(sdr["gid"].ToString());
        //            g.gname = sdr["gname"].ToString();

        //            groundlist.Add(g);
        //        }
        //        sdr.Close();
        //        con.Close();

        //        return Request.CreateResponse(HttpStatusCode.OK, groundlist);


        //    }
        //    catch(Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError,ex.Message);

        //    }     
        //}
        [HttpGet]
        public HttpResponseMessage flist()
        {
            try
            {
                var list = db.facilities.Select(x=> new {x.id,x.name});
                return Request.CreateResponse(HttpStatusCode.OK, list);
            }
            catch(Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError,ex.Message);
            }
        }
        //[HttpGet]
        //public HttpResponseMessage clist()
        //{
        //    try
        //    {
        //        var list = db.cities.Select(x => new { x.id, x.name });
        //        return Request.CreateResponse(HttpStatusCode.OK, list);
        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
     
        [HttpGet]
        public HttpResponseMessage clist(int id)
        {
            try
            {
                //     var distinctCities = db.grounds
                //.Select(g => new { g.city })
                //.Distinct()
                //;

                //return distinctCities;
                var list = db.cities.Select(x => new { x.id,x.name }).Distinct();
                return Request.CreateResponse(HttpStatusCode.OK, list);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpGet]
        public HttpResponseMessage arealist(int cityid)
        {
            try
            {
                var list = db.areas.Select(x => new {x.cityid, x.name }).Distinct();
                return Request.CreateResponse(HttpStatusCode.OK, list);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        [HttpPost]
        public HttpResponseMessage addarea(int cityid,string area)
        {
            try
            {
                area a = new area();
                a.name = area;
                a.cityid = cityid;
                db.areas.Add(a);
                db.SaveChanges();


                return Request.CreateResponse(HttpStatusCode.OK, "Added");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        public HttpResponseMessage Addcity(string city)
        {
            try
            {
                city c = new city();
                c.name = city;
                
                db.cities.Add(c);
                db.SaveChanges();
              
                return Request.CreateResponse(HttpStatusCode.OK, "Added");
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        //[HttpGet]
        //public HttpResponseMessage areas(int id)
        //{
        //    try
        //    {
        //        var list = db.areas.Where(c=>c.cityid==id).Select(x => new { x.id, x.name });
        //        return Request.CreateResponse(HttpStatusCode.OK, list);
        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        [HttpGet]
        public HttpResponseMessage areas(string city)
        {
            try
            {
                var list = db.grounds.Where(x => x.city == city).Select(x => new { x.area }).Distinct();
                return Request.CreateResponse(HttpStatusCode.OK, list);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
       
        //[HttpGet]
        //public HttpResponseMessage Delete(int id)
        //{
        //    try
        //    {
        //        //var flist = db.ground_facility.Where(g => g.gid == id).ToList();

        //        var list = db.grounds.Where(g => g.gid == id).FirstOrDefault();

        //        if (list!=null)
        //        {
        //            db.grounds.Remove(list);
        //            db.SaveChanges();
        //            return Request.CreateResponse(HttpStatusCode.OK, "Deleted");
        //        }

        //        return Request.CreateResponse(HttpStatusCode.OK, "No Record Found at "+id);
        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }

        //}
        [HttpGet]
        public HttpResponseMessage Delete(int id)
        {
            try
            {
                //var flist = db.ground_facility.Where(g => g.gid == id).ToList();

                var list = db.grounds.Where(g => g.gid == id).FirstOrDefault();
                var groundsToRemove = db.ground_facility.Where(g => g.gid == id);
                // Remove the ground_facility entries from the database
                db.ground_facility.RemoveRange(groundsToRemove);
                var bookingtoremove = db.bookings.Where(g => g.gid == id);
                // Remove the ground_facility entries from the database
                db.bookings.RemoveRange(bookingtoremove);
                var rating = db.feedbacks.Where(g => g.gid == id);
                // Remove the ground_facility entries from the database
                db.feedbacks.RemoveRange(rating);
                var membership = db.memberships.Where(g => g.gid == id);
                // Remove the ground_facility entries from the database
                db.memberships.RemoveRange(membership);
                var schedule = db.schedules.Where(g => g.gid == id);
                // Remove the ground_facility entries from the database
                db.schedules.RemoveRange(schedule);

                db.SaveChanges();
                // Save the changes to the database

                if (list != null)
                {
                    db.grounds.Remove(list);
                    db.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK, "Deleted");
                }

                return Request.CreateResponse(HttpStatusCode.OK, "No Record Found at " + id);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }

        }
        [HttpGet]
        public HttpResponseMessage GetImage(int id)
        {
            var glist = db.grounds.Where(g => g.oid == id).Select(x => new {  x.image }).FirstOrDefault();

          //  var image = db.grounds.Where(x => x.oid == id).Select(g => g.image).FirstOrDefault();

        if (glist == null)
            {
                return Request.CreateResponse(HttpStatusCode.NotFound);
            }
            string path = HttpContext.Current.Server.
                                      MapPath("~/Content/Uploads/");
            var imageName = glist.image; // assuming your image model has a 'Name' property
            var imagePath = Path.Combine(path, imageName); // replace with your own server path
            if (!File.Exists(imagePath))
            {
                return Request.CreateResponse(HttpStatusCode.NotFound);
            }
            // replace with your own image type
            return Request.CreateResponse(HttpStatusCode.OK, imagePath);
        }

        [HttpPost]
        public HttpResponseMessage AvailableGroundsRange()
        {
            try
            {
                DateTime fromdate = new DateTime();
                DateTime todate = new DateTime();
                HttpRequest request = HttpContext.Current.Request;
                ground grd = new ground();
                grd.city = request["city"];
                grd.area = request["area"];
                grd.gtype = request["gtype"];
                var lof = request["list[]"];
                List<int> fidlist = new List<int>();
                if (lof != null)
                {
                    string[] values = lof.Split(',').Select(sValue => sValue.Trim()).ToArray();
                    for (int i = 0; i < values.Length; i++)
                    {
                        int id = int.Parse(values[i]);
                        fidlist.Add(id);
                    }
                }
                if (request["fromdate"] != "")
                {
                    grd.Fromdate = DateTime.Parse(request["fromdate"]);
                    fromdate = DateTime.Parse(grd.Fromdate.ToString());
                }
                if (request["todate"] != "")
                {
                    grd.Todate = DateTime.Parse(request["todate"]);
                    todate = DateTime.Parse(grd.Todate.ToString());
                }
                List<string> listofdays = new List<string>();
                for (DateTime date = fromdate; date <= todate; date = date.AddDays(1))
                {
                    string day = date.DayOfWeek.ToString();
                    listofdays.Add(day);
                }
                if (request["stime"] != "")
                {
                    grd.stime = TimeSpan.Parse(request["stime"]);
                }
                if (request["etime"] != "")
                {
                    grd.etime = TimeSpan.Parse(request["etime"]);
                }

                //check city with all
                if (grd.city != "" && grd.area == null && grd.gtype == null && grd.Fromdate == null && grd.Todate == null && grd.stime == null && grd.etime == null && fidlist.Count == 0)
                {
                    var availablegroundsarea = from g in db.grounds
                                               where g.city == grd.city
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city != null && grd.area == null && grd.gtype == null && grd.Fromdate == null && grd.Todate == null && grd.stime == null && grd.etime == null && fidlist.Count == 0)
                {
                    var availablegroundsarea = from g in db.grounds
                                               where g.city == grd.city && g.area == grd.area
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city != null && grd.area != null && grd.gtype != null && grd.Fromdate == null && grd.Todate == null && grd.stime == null && grd.etime == null && fidlist.Count == 0)
                {
                    var availablegroundsarea = from g in db.grounds
                                               where g.area == grd.area && g.city == grd.city && g.gtype == grd.gtype
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city != null && grd.area != null && grd.gtype != null && grd.Fromdate != null && grd.Todate == null && grd.stime == null && grd.etime == null && fidlist.Count == 0)
                {
                    var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where g.area == grd.area && g.city == grd.city && g.gtype == grd.gtype
                                           && !db.bookings.Any(booking =>
           booking.gid == g.gid &&
          booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Fromdate &&
           booking.status == "Approved"
              ) &&
          db.schedules.Any(schedule =>
              schedule.gid == g.gid &&
              schedule.day == day
          )
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city != null && grd.area != null && grd.gtype != null && grd.Fromdate != null && grd.Todate != null && grd.stime == null && grd.etime == null && fidlist.Count == 0)
                {
                    var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where g.area == grd.area && g.city == grd.city && g.gtype == grd.gtype
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.status == "Approved"
              ) && db.schedules.Where(schedule =>
                                         listofdays.Contains(schedule.day)
                                         && schedule.gid == g.gid

                                        )
                                        .Count() == listofdays.Count
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city != null && grd.area != null && grd.gtype != null && grd.Fromdate != null && grd.Todate != null && grd.stime != null && grd.etime == null && fidlist.Count == 0)
                {
                    //var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where g.area == grd.area && g.city == grd.city && g.gtype == grd.gtype
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.s_time <= grd.stime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Where(schedule =>
                                         listofdays.Contains(schedule.day)
                                         && schedule.gid == g.gid
                                          && schedule.starttime <= grd.stime && schedule.endtime >= grd.stime
                                        )
                                        .Count() == listofdays.Count
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city != null && grd.area != null && grd.gtype != null && grd.Fromdate != null && grd.Todate != null && grd.stime != null && grd.etime != null && fidlist.Count == 0)
                {
                    //var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where g.area == grd.area && g.city == grd.city && g.gtype == grd.gtype
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.s_time <= grd.etime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Where(schedule =>
                                         listofdays.Contains(schedule.day)
                                         && schedule.gid == g.gid
                                          && schedule.starttime <= grd.etime && schedule.endtime >= grd.stime
                                              && schedule.starttime <= grd.etime && schedule.endtime >= grd.etime
                                        )
                                        .Count() == listofdays.Count
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city != null && grd.area == null && grd.gtype != null && grd.Fromdate != null && grd.Todate != null && grd.stime != null && grd.etime != null && fidlist.Count != 0)
                {
                    //var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where fidlist.All(fid => g.ground_facility.Any(gf => gf.fid == fid)) && g.area == grd.area && g.city == grd.city && g.gtype == grd.gtype
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.s_time <= grd.etime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Where(schedule =>
                                         listofdays.Contains(schedule.day)
                                         && schedule.gid == g.gid
                                          && schedule.starttime <= grd.stime && schedule.endtime >= grd.stime
                                           && schedule.starttime <= grd.etime && schedule.endtime >= grd.etime
                                        )
                                        .Count() == listofdays.Count
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city != null && grd.area == null && grd.gtype != null && grd.Fromdate != null && grd.Todate != null && grd.stime != null && grd.etime != null && fidlist.Count == 0)
                {
                    //var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where g.city == grd.city && g.gtype == grd.gtype
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.s_time <= grd.etime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Where(schedule =>
                                         listofdays.Contains(schedule.day)
                                         && schedule.gid == g.gid
                                          && schedule.starttime <= grd.stime && schedule.endtime >= grd.stime
                                           && schedule.starttime <= grd.etime && schedule.endtime >= grd.etime
                                        )
                                        .Count() == listofdays.Count
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                //check area with all
                else if (grd.city == null && grd.area != null && grd.gtype == null && grd.Fromdate == null && grd.Todate == null && grd.stime == null && grd.etime == null && fidlist.Count == 0)
                {
                    var availablegroundsarea = from g in db.grounds
                                               where g.area == grd.area
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area != null && grd.gtype != null && grd.Fromdate == null && grd.Todate == null && grd.stime == null && grd.etime == null && fidlist.Count == 0)
                {
                    var availablegroundsarea = from g in db.grounds
                                               where g.area == grd.area && g.gtype == grd.gtype
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area != null && grd.gtype != null && grd.Fromdate != null && grd.Todate == null && grd.stime == null && grd.etime == null && fidlist.Count == 0)
                {
                    var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where g.area == grd.area && g.gtype == grd.gtype
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Fromdate &&
              booking.status == "Approved"
              ) &&
          db.schedules.Any(schedule =>
              schedule.gid == g.gid &&
              schedule.day == day
          )
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area != null && grd.gtype != null && grd.Fromdate != null && grd.Todate != null && grd.stime == null && grd.etime == null && fidlist.Count == 0)
                {
                    var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where g.area == grd.area && g.gtype == grd.gtype
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.status == "Approved"
              ) && db.schedules.Where(schedule =>
                                         listofdays.Contains(schedule.day)
                                         && schedule.gid == g.gid
                                          && schedule.starttime <= grd.etime && schedule.endtime >= grd.stime
                                        )
                                        .Count() == listofdays.Count
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area != null && grd.gtype != null && grd.Fromdate != null && grd.Todate != null && grd.stime != null && grd.etime == null && fidlist.Count == 0)
                {
                    //var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where g.area == grd.area && g.gtype == grd.gtype
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.s_time <= grd.stime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Where(schedule =>
                                         listofdays.Contains(schedule.day)
                                         && schedule.gid == g.gid
                                          && schedule.starttime <= grd.stime && schedule.endtime >= grd.stime
                                        )
                                        .Count() == listofdays.Count
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area != null && grd.gtype != null && grd.Fromdate != null && grd.Todate != null && grd.stime != null && grd.etime != null && fidlist.Count == 0)
                {
                    //var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where g.area == grd.area && g.gtype == grd.gtype
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.s_time <= grd.etime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Where(schedule =>
                                         listofdays.Contains(schedule.day)
                                         && schedule.gid == g.gid
                                          && schedule.starttime <= grd.etime && schedule.endtime >= grd.stime
                                        )
                                        .Count() == listofdays.Count
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area != null && grd.gtype != null && grd.Fromdate != null && grd.Todate != null && grd.stime != null && grd.etime != null && fidlist.Count != 0)
                {
                    //var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where fidlist.All(fid => g.ground_facility.Any(gf => gf.fid == fid)) && g.area == grd.area && g.gtype == grd.gtype
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.s_time <= grd.etime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Where(schedule =>
                                         listofdays.Contains(schedule.day)
                                         && schedule.gid == g.gid
                                          && schedule.starttime <= grd.etime && schedule.endtime >= grd.stime
                                        )
                                        .Count() == listofdays.Count
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }

                // check area
                //check gtype with all
                else if (grd.city == null && grd.area == null && grd.gtype != null && grd.Fromdate == null && grd.Todate == null && grd.stime == null && grd.etime == null && fidlist.Count == 0)
                {
                    var availablegroundsarea = from g in db.grounds
                                               where g.gtype == grd.gtype
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area == null && grd.gtype != null && grd.Fromdate != null && grd.Todate == null && grd.stime == null && grd.etime == null && fidlist.Count == 0)
                {
                    var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where g.gtype == grd.gtype
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Fromdate &&
              booking.status == "Approved"
              ) &&
          db.schedules.Any(schedule =>
              schedule.gid == g.gid &&
              schedule.day == day
          )
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area == null && grd.gtype != null && grd.Fromdate != null && grd.Todate != null && grd.stime == null && grd.etime == null && fidlist.Count == 0)
                {
                    var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where g.gtype == grd.gtype
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.status == "Approved"
              ) && db.schedules.Where(schedule =>
                                         listofdays.Contains(schedule.day)
                                         && schedule.gid == g.gid
                                          && schedule.starttime <= grd.etime && schedule.endtime >= grd.stime
                                        )
                                        .Count() == listofdays.Count
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area == null && grd.gtype != null && grd.Fromdate != null && grd.Todate != null && grd.stime != null && grd.etime == null && fidlist.Count == 0)
                {
                    //var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where g.gtype == grd.gtype
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.s_time <= grd.stime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Where(schedule =>
                                         listofdays.Contains(schedule.day)
                                         && schedule.gid == g.gid
                                          && schedule.starttime <= grd.stime && schedule.endtime >= grd.stime
                                        )
                                        .Count() == listofdays.Count
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area == null && grd.gtype != null && grd.Fromdate != null && grd.Todate != null && grd.stime != null && grd.etime != null && fidlist.Count == 0)
                {
                    //var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where g.gtype == grd.gtype
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.s_time <= grd.etime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Where(schedule =>
                                         listofdays.Contains(schedule.day)
                                         && schedule.gid == g.gid
                                          && schedule.starttime <= grd.etime && schedule.endtime >= grd.stime
                                        )
                                        .Count() == listofdays.Count
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area == null && grd.gtype != null && grd.Fromdate != null && grd.Todate != null && grd.stime != null && grd.etime != null && fidlist.Count != 0)
                {
                    //var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where fidlist.All(fid => g.ground_facility.Any(gf => gf.fid == fid)) && g.gtype == grd.gtype
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.s_time <= grd.etime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Where(schedule =>
                                         listofdays.Contains(schedule.day)
                                         && schedule.gid == g.gid
                                          && schedule.starttime <= grd.etime && schedule.endtime >= grd.stime
                                        )
                                        .Count() == listofdays.Count
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }

                // check gtpe
                //check fromdate with all
                else if (grd.city == null && grd.area == null && grd.gtype == null && grd.Fromdate != null && grd.Todate == null && grd.stime == null && grd.etime == null && fidlist.Count == 0)
                {
                    var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where
                                            !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Fromdate &&
              booking.status == "Approved"
              ) &&
          db.schedules.Any(schedule =>
              schedule.gid == g.gid &&
              schedule.day == day
          )
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area == null && grd.gtype == null && grd.Fromdate != null && grd.Todate != null && grd.stime == null && grd.etime == null && fidlist.Count == 0)
                {
                    var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where
                                            !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.status == "Approved"
              ) && db.schedules.Where(schedule =>
                                         listofdays.Contains(schedule.day)
                                         && schedule.gid == g.gid
                                          && schedule.starttime <= grd.etime && schedule.endtime >= grd.stime
                                        )
                                        .Count() == listofdays.Count
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area == null && grd.gtype == null && grd.Fromdate != null && grd.Todate != null && grd.stime != null && grd.etime == null && fidlist.Count == 0)
                {
                    //var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where
                                            !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.s_time <= grd.stime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Where(schedule =>
                                         listofdays.Contains(schedule.day)
                                         && schedule.gid == g.gid
                                          && schedule.starttime <= grd.stime && schedule.endtime >= grd.stime
                                        )
                                        .Count() == listofdays.Count
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area == null && grd.gtype == null && grd.Fromdate != null && grd.Todate != null && grd.stime != null && grd.etime != null && fidlist.Count == 0)
                {
                    //var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where
                                            !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.s_time <= grd.etime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Where(schedule =>
                                         listofdays.Contains(schedule.day)
                                         && schedule.gid == g.gid
                                          && schedule.starttime <= grd.etime && schedule.endtime >= grd.stime
                                        )
                                        .Count() == listofdays.Count
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area == null && grd.gtype == null && grd.Fromdate != null && grd.Todate != null && grd.stime != null && grd.etime != null && fidlist.Count != 0)
                {
                    //var day = fromdate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where fidlist.All(fid => g.ground_facility.Any(gf => gf.fid == fid))
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.s_time <= grd.etime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Where(schedule =>
                                         listofdays.Contains(schedule.day)
                                         && schedule.gid == g.gid
                                          && schedule.starttime <= grd.etime && schedule.endtime >= grd.stime
                                        )
                                        .Count() == listofdays.Count
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }

                // check fromdate
                //check todate with all
                else if (grd.city == null && grd.area == null && grd.gtype == null && grd.Fromdate == null && grd.Todate != null && grd.stime == null && grd.etime == null && fidlist.Count == 0)
                {
                    var day = todate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where
                                            !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Todate && booking.Fromdate <= grd.Todate &&
              booking.status == "Approved"
              ) &&
          db.schedules.Any(schedule =>
              schedule.gid == g.gid &&
              schedule.day == day
          )
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area == null && grd.gtype == null && grd.Fromdate == null && grd.Todate != null && grd.stime != null && grd.etime == null && fidlist.Count == 0)
                {
                    var day = todate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where
                                            !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Todate && booking.Fromdate <= grd.Todate &&
              booking.s_time <= grd.stime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Any(schedule =>
              schedule.gid == g.gid &&
              schedule.day == day &&
              schedule.starttime <= grd.stime &&
              schedule.endtime >= grd.stime
          )
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area == null && grd.gtype == null && grd.Fromdate == null && grd.Todate != null && grd.stime != null && grd.etime != null && fidlist.Count == 0)
                {
                    var day = todate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where
                                            !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate &&
              booking.s_time <= grd.etime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Any(schedule =>
              schedule.gid == g.gid &&
              schedule.day == day &&
              schedule.starttime <= grd.etime &&
              schedule.endtime >= grd.stime
          )

                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == null && grd.area == null && grd.gtype == null && grd.Fromdate == null && grd.Todate != null && grd.stime != null && grd.etime != null && fidlist.Count != 0)
                {
                    var day = todate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where fidlist.All(fid => g.ground_facility.Any(gf => gf.fid == fid))
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&
             booking.Todate >= grd.Todate && booking.Fromdate <= grd.Todate &&
              booking.s_time <= grd.etime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Any(schedule =>
               schedule.gid == g.gid &&
               schedule.day == day &&
               schedule.starttime <= grd.etime &&
               schedule.endtime >= grd.stime
          )
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }

                // check todate
                //check stime with all
                else if (grd.city == null && grd.area == null && grd.gtype == null && grd.Fromdate == null && grd.Todate == null && grd.stime != null && grd.etime == null && fidlist.Count == 0)
                {
                    var day = todate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where
                                            !db.bookings.Any(booking =>
              booking.gid == g.gid &&

              booking.s_time <= grd.stime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Any(schedule =>
              schedule.gid == g.gid &&
              schedule.day == day &&
              schedule.starttime <= grd.stime &&
              schedule.endtime >= grd.stime
          )
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == "" && grd.area == "" && grd.gtype == "" && grd.Fromdate == null && grd.Todate == null && grd.stime != null && grd.etime != null && fidlist.Count == 0)
                {
                    var day = todate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where
                                            !db.bookings.Any(booking =>
              booking.gid == g.gid &&

              booking.s_time <= grd.etime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Any(schedule =>
              schedule.gid == g.gid &&
              schedule.day == day &&
              schedule.starttime <= grd.etime &&
              schedule.endtime >= grd.stime
          )
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == "" && grd.area == "" && grd.gtype == "" && grd.Fromdate == null && grd.Todate == null && grd.stime != null && grd.etime != null && fidlist.Count != 0)
                {
                    var day = todate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where fidlist.All(fid => g.ground_facility.Any(gf => gf.fid == fid))
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&

              booking.s_time <= grd.etime &&
              booking.e_time >= grd.stime &&
              booking.status == "Approved"
              ) && db.schedules.Any(schedule =>
              schedule.gid == g.gid &&
              schedule.day == day &&
              schedule.starttime <= grd.etime &&
              schedule.endtime >= grd.stime
          )
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }

                // check stime
                //check etime with all
                else if (grd.city == "" && grd.area == "" && grd.gtype == "" && grd.Fromdate == null && grd.Todate == null && grd.stime == null && grd.etime != null && fidlist.Count == 0)
                {
                    var day = todate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where
                                            !db.bookings.Any(booking =>
              booking.gid == g.gid &&

              booking.s_time <= grd.etime &&
              booking.e_time >= grd.etime &&
              booking.status == "Approved"
              ) && db.schedules.Any(schedule =>
              schedule.gid == g.gid &&
              schedule.day == day &&
              schedule.starttime <= grd.etime &&
              schedule.endtime >= grd.etime
          )
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }
                else if (grd.city == "" && grd.area == "" && grd.gtype == "" && grd.Fromdate == null && grd.Todate == null && grd.stime == null && grd.etime != null && fidlist.Count != 0)
                {
                    var day = todate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where fidlist.All(fid => g.ground_facility.Any(gf => gf.fid == fid))
                                           && !db.bookings.Any(booking =>
              booking.gid == g.gid &&

              booking.s_time <= grd.etime &&
              booking.e_time >= grd.etime &&
              booking.status == "Approved"
              ) && db.schedules.Any(schedule =>
              schedule.gid == g.gid &&
              schedule.day == day &&
              schedule.starttime <= grd.etime &&
              schedule.endtime >= grd.etime
          )
                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }


                //  //check facility with all
                else if (grd.city == "" && grd.area == "" && grd.gtype == "" && grd.Fromdate == null && grd.Todate == null && grd.stime == null && grd.etime == null && fidlist.Count != 0)
                {
                    var day = todate.DayOfWeek.ToString();
                    var availablegroundsarea = from g in db.grounds
                                               where fidlist.All(fid => g.ground_facility.Any(gf => gf.fid == fid))

                                               select new
                                               {
                                                   g.gid,
                                                   g.gname,
                                                   g.city,
                                                   g.area,
                                                   g.capacity,
                                                   g.description,
                                                   g.image,
                                                   flist = from gf in db.ground_facility
                                                           join f in db.facilities on gf.fid equals f.id
                                                           where gf.gid == g.gid
                                                           select new { f.name },
                                                   averagerating = db.feedbacks
                                   .Where(f => f.gid == g.gid)
                                   .Average(f => f.rating),
                                                   totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
                                               };
                    return Request.CreateResponse(HttpStatusCode.OK, availablegroundsarea);
                }

                // check stime



                var availableGrounds =
from g in db.grounds
where fidlist.All(fid => g.ground_facility.Any(gf => gf.fid == fid)) &&
g.city == grd.city && g.area == grd.area && g.gtype == grd.gtype &&
!db.bookings.Any(booking =>
    booking.gid == g.gid &&
    (booking.Todate >= grd.Fromdate && booking.Fromdate <= grd.Todate) &&
    booking.s_time <= grd.etime &&
    booking.e_time >= grd.stime &&
    booking.status == "Approved"
    )
 && db.schedules.Where(schedule =>
                               listofdays.Contains(schedule.day)
                               && schedule.gid == g.gid
                               && schedule.starttime <= grd.etime && schedule.endtime >= grd.stime)
                              .Count() == listofdays.Count
select new
{
    g.gid,
    g.gname,
    g.city,
    g.area,
    g.capacity,
    g.description,
    g.image,
    flist = from gf in db.ground_facility
            join f in db.facilities on gf.fid equals f.id
            where gf.gid == g.gid
            select new { f.name },
    averagerating = db.feedbacks
    .Where(f => f.gid == g.gid)
    .Average(f => f.rating),
    totalreviews = db.feedbacks.Where(f => f.gid == g.gid).Count()
};
                return Request.CreateResponse(HttpStatusCode.OK, availableGrounds);
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }


    }


}

