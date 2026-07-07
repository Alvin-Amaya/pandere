import { Donor } from "./actor";

export class Project {
    constructor (
        public readonly id: number, 
        public name: string,
        public description: string,
        public startDate: Date,
        public endDate: Date,
        public status: Status,
        private statusHistory: StatusHistory[] = []
    ) {}

    transitionTo(newStatus: Status, date: Date) {
        this.status = newStatus;
        this.statusHistory.push({ status: newStatus, startDate: date });
    }

    get currentStatus() {
        return this.status;
    }
}

export interface Status { id: number; name: string; }
export interface StatusHistory { status: Status; startDate: Date; endDate?: Date }

export class Currency {}

export class Donation {
    constructor(
        public readonly id: number,
        public donor: Donor,
        public project: Project,
        public currency: Currency,
        public amount: number,
        public date: Date,
        public isRestrictive: boolean
    ) {}
}