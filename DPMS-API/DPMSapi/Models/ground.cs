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
    
    public partial class ground
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public ground()
        {
            this.bookings = new HashSet<booking>();
            this.feedbacks = new HashSet<feedback>();
            this.ground_facility = new HashSet<ground_facility>();
            this.memberships = new HashSet<membership>();
            this.schedules = new HashSet<schedule>();
        }

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
        public virtual appuser appuser { get; set; }
        public Nullable<System.DateTime> Fromdate { get; set; }
        public Nullable<System.DateTime> Todate { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<booking> bookings { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<feedback> feedbacks { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ground_facility> ground_facility { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<membership> memberships { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<schedule> schedules { get; set; }
        public virtual ground ground1 { get; set; }
        public virtual ground ground2 { get; set; }
    }
}