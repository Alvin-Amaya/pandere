export class Actor {
    constructor(public readonly id: number, public readonly email: string) {}
    public telephones = [];
    public addresses: Address[] = [];
}

export class Person extends Actor {
    constructor(
        id: number, 
        email: string, 
        public firstName: string, 
        public middleName: string | null, 
        public firstSurname: string, 
        public SecondSurname: string | null,
        public dni: string,
        public birth: Date
    ) { super(id, email); }
}

export class Enterprise extends Actor {
    constructor(
        id: number,
        email: string,
        public name: string,
        public rtn: string,
        public bussinesSector: string,
    ) { super(id, email) }
}

export class User extends Actor {
    constructor(
        id: number,
        email: string,
        public nickname: string,
        public password: string,
    ) { super(id, email) }
}

export class Donor extends Actor {}

export class Volunteer extends Actor {}

export class Staff extends Actor {}

export type Location = {
    id: number,
    name: string,
    parent: Location
}

export class Address {
    constructor(
        public readonly id: number, 
        public type: string,
    ) {}
}
