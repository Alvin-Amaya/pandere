import { Service } from "./service";
import { User } from "./types";

export default class UserService extends Service<User> {
    async hashPassword(password: string): Promise<string> {
        return password;
    }

    override async create(user: User): Promise<User> {
        const hashedPassword = await this.hashPassword(user.password);
        user.password = hashedPassword;
        return this.repository.create(user);
    }

}
