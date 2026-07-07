import { IRepository } from '@/application/ports/repository';
import { User } from '@/domain/actor';
import { db } from './client';

export class PrismaUserRepository implements IRepository<User> {
    async findById(id: number): Promise<User> {
        const user = await db.users.findUnique({
            where: { id },
            include: { actor: true },
        });

        if (!user || !user.actor) {
            throw new Error(`User with id ${id} not found.`);
        }

        return {
            id: user.id,
            email: user.actor.email,
        } as User;
    }

    async save(item: Omit<User, 'id'>): Promise<User> {
        return await db.$transaction(async (tx) => {
            const actor = await tx.actor.create({ data: { email: item.email } });
            const user = await tx.users.create({
                data: {
                    actor_id: actor.id,
                    role_id: 1,
                    nickname: `user-${actor.id}`,
                    password: "temp-password",
                },
                include: { actor: true },
            });

            return {
                id: user.id,
                email: user.actor.email,
            } as User;
        });
    }
}