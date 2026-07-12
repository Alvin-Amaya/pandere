import { IRepository } from "@/domain/repository";

export interface IDataModel<DB> {
  findUnique(args: { where: { id: number } }): Promise<DB | null>;
  findMany(): Promise<DB[]>;
  create(args: { data: DB }): Promise<DB>;
  delete(args: { where: { id: number } }): Promise<DB>;
}

export class Repository<T> implements IRepository<T> {
  constructor(protected model: IDataModel<T>) {}

  async getAll(): Promise<T[]> {
    return await this.model.findMany();
  }

  async delete(id: number): Promise<void> {
    await this.model.delete({ where: { id } });
  }

  async findById(id: number): Promise<T | null> {
    return await this.model.findUnique({ where: { id } });
  }

  async save(item: T): Promise<T> {
    return await this.model.create({ data: item });
  }
}