using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DPMSapi.Models
{
    public class earning
    {
      public  int totalbookings { get; set; }
      public  double totalbookingearning { get; set; }
        public int totalmembers { get; set; }
        public double totalmemberearning { get; set; }

        public double totalearning { get; set; }
    }
}