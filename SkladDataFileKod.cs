using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace SkladData {
    class SkladDataFileKod : SkladDataFile {

        public SkladDataFileKod(string[] lines) : base(lines) {
        }

        public override string GetID(string id) {
            return id;
        }

        public override bool IsValidHeaderLine(string line) {
            Regex r = new Regex(@"^");
            return r.IsMatch(line);
        }
        public override bool IsValidDataLine(string line) {
            Regex r = new Regex(@"^\s{2}\p{N}{4}\s{3}");
            return r.IsMatch(line);
        }
    }
}