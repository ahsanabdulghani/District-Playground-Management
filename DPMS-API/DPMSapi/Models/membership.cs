//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace DPMSapi.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class membership
    {
        public int id { get; set; }
        public Nullable<System.DateTime> requestdate { get; set; }
        public Nullable<System.DateTime> joindate { get; set; }
        public Nullable<System.DateTime> enddate { get; set; }
        public Nullable<int> amount { get; set; }
        public string duration { get; set; }
        public string status { get; set; }
        public Nullable<int> gid { get; set; }
        public Nullable<int> cid { get; set; }
    
        public virtual appuser appuser { get; set; }
        public virtual ground ground { get; set; }
    }
}
