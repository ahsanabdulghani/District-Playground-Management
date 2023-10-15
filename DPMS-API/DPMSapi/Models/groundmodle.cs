using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DPMSapi.Models
{
    public class groundmodle
    {
        public Nullable<System.DateTime> matchdate { get; set; }
        public Nullable<System.TimeSpan> stime { get; set; }
        public Nullable<System.TimeSpan> etime { get; set; }
        public int gid { get; set; }
        public string gname { get; set; }
        public string city { get; set; }
        public string area { get; set; }
        public Nullable<int> capacity { get; set; }
        public string gtype { get; set; }
        public string contact { get; set; }
        public string image { get; set; }
        public string address { get; set; }
        public string description { get; set; }
        public string size { get; set; }
        public Nullable<int> oid { get; set; }
        public string m_duration { get; set; }
        public Nullable<int> mfee { get; set; }
        public Nullable<int> disc { get; set; }
    }
}