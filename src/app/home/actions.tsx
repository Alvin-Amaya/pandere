'use server'

import { projects } from "@/domain/project";

export async function getProjects() {
    return projects.getAll();
}

