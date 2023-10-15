using DPMSapi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.UI.WebControls;

namespace apiDPMS.Controllers
{
    public class apiAccountController : ApiController
    {
        playgroundEntities4 db = new playgroundEntities4();
        //[HttpPost]
        //public HttpResponseMessage Signup(appuser newuser)
        //{
        //    try
        //    {
        //        var user = db.appusers.Where(s => s.email.ToLower() == newuser.email.ToLower()).FirstOrDefault();
        //        if (user != null)
        //            return Request.CreateResponse(HttpStatusCode.OK, "Exsist");

        //        db.appusers.Add(newuser);
        //        db.SaveChanges();
        //        return Request.CreateResponse(HttpStatusCode.OK, "Created");

        //    }
        //    catch (Exception ex)
        //    {

        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }
        //}
        //[HttpPost]
        //public HttpResponseMessage Login(appuser user)
        //{
        //    try
        //    {

        //        var userdata = db.appusers.Where(s => s.email == user.email && s.password == user.password).Select(u => new {u.id, u.name, u.email,u.contact,u.role,u.password }).FirstOrDefault();

        //        return Request.CreateResponse(HttpStatusCode.OK, userdata);

        //    }
        //    catch (Exception ex)
        //    {

        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
        //    }

        //}
        [HttpPost]
        public HttpResponseMessage Signup(string email, string password, string contact, string name, string role)
        {
            try
            {
                // Check if a user with the given email already exists
                var existingUser = db.appusers.SingleOrDefault(u => u.email == email);
                if (existingUser != null)
                {
                    return Request.CreateResponse(HttpStatusCode.BadRequest, "User already exists");
                }

                // Create a new user with the given email and password
                var newUser = new appuser
                {
                    email = email,
                    password = password,
                    role = role,
                    contact = contact,
                    name = name

                };
                db.appusers.Add(newUser);
                db.SaveChanges();

                // Return the new user object
                return Request.CreateResponse(HttpStatusCode.OK, new
                {
                    newUser.email,
                    newUser.password,
                    newUser.role,
                    newUser.contact,
                    newUser.name
                });
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message);
            }
        }


        [HttpGet]

        public HttpResponseMessage Login(string email, string password)
        {
            try
            {
                Login u = new Login();
                var v = db.appusers.Where(s => s.email == email && s.password == password).ToList();
                if (v != default)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, v.Select(s => new
                    {
                        s.id,
                        s.email,
                        s.password,
                        s.role
                    }).First());

                }
                return Request.CreateResponse(HttpStatusCode.OK, "User not found");

            }
            catch (Exception ex)
            {

                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message); ;
            }

        }
    }
}
