import React, { useEffect } from "react";
import "../css/LockerDashboard.css";
import { Lockerbox } from "./Lockerbox";
import { Lockershow } from "./Lockershow";
import { auth } from "../config/config";
import { useHistory } from "react-router-dom";

export const LockerDashboard = ({ user, userID, locationID }) => {
  const history = useHistory();

  useEffect(() => {
    auth.onAuthStateChanged((user) => {
      if (!user) {
        history.push("/");
      }
    });
  });

  return (
    <div className="lockerboard">
      <div className="gradient__bg">
        <Lockerbox user={user} userID={userID} />
        <Lockershow user={user} userID={userID} />
      </div>
    </div>
  );
};

export default LockerDashboard;
