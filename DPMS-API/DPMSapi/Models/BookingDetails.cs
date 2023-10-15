using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DPMSapi.Models
{
    public class BookingDetails
    {
        public string gname { get; set; }
        public string city { get; set; }
        public string area { get; set; }
        public int id { get; set; }
        public Nullable<int> gid { get; set; }
        public Nullable<int> cid { get; set; }
        public Nullable<System.DateTime> requestdate { get; set; }
        public Nullable<System.DateTime> matchdate { get; set; }
        public Nullable<System.TimeSpan> s_time { get; set; }
        public Nullable<System.TimeSpan> e_time { get; set; }
        public string status { get; set; }
        public Nullable<int> amount { get; set; }
        public string mlevel { get; set; }
        public string c_name { get; set; }
        public double feeperhr { get; set; }
        public string hours { get; set; }
        public double totalfee { get; set; }
        public double discount { get; set; }
        public double TotalAmount { get; set; }

        public virtual appuser appuser { get; set; }
        public virtual ground ground { get; set; }
        public Nullable<System.TimeSpan> request_time { get; set; }
        public Nullable<System.DateTime> Fromdate { get; set; }
        public Nullable<System.DateTime> Todate { get; set; }


    }
}