using DPMSapi.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity.Migrations;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography;
using System.Web;
using System.Web.Http;

namespace DPMSapi.Controllers
{
    public class RatingController : ApiController
    {
        playgroundEntities4 db = new playgroundEntities4();
        [HttpPost]
        public HttpResponseMessage AddRating()
        {
            try
            {
                HttpRequest request = HttpContext.Current.Request;
                DateTime dt = DateTime.Now.Date;
                feedback f = new feedback();
                f.gid = int.Parse(request["gid"]);
                f.cid = int.Parse(request["cid"]);
                f.comment = request["comment"];
                f.rating = int.Parse(request["rating"]);
                f.f_date = DateTime.Parse(dt.ToString("MMMM dd,yyyy"));

                db.feedbacks.AddOrUpdate(f);
                db.SaveChanges();
                return Request.CreateResponse(HttpStatusCode.OK, "Added");
            
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
    }
}
