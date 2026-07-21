import { Options } from "./repository";
import { Service } from "./service";
import { User, Volunteer } from "./types";

export class UserService extends Service<User> {
    async hashPassword(password: string): Promise<string> {
        return password;
    }

    override async create(user: User): Promise<User> {
        const hashedPassword = await this.hashPassword(user.password);
        user.password = hashedPassword;
        return this.repository.create(user);
    }

    override async findById(id: number, options?: Options<User>): Promise<User | null> {
        const user = await this.repository.findById(id, {
            include: {
                password: false,
                actor: true,
            },
            ...options,
        });

        if (!user) return null;
        return user;
    }

    async getAll(options?: Options<User>): Promise<User[]> {
        return this.repository.getAll({
            include: {
                password: false,
                actor: true,
            },
            ...options,
        });
    }
}

export class VolunteerService extends Service<Volunteer> {
    override async findById(id: number, options?: Options<Volunteer>): Promise<Volunteer | null> {
        const volunteer = await this.repository.findById(id, {
            include: {
                actor: true,
            },
            ...options,
        });

        if (!volunteer) return null;
        return volunteer;
    }

    override async getAll(options?: Options<Volunteer>): Promise<Volunteer[]> {
        return this.repository.getAll({
            include: {
                actor: true,
            },
            ...options,
        });
    }
}
