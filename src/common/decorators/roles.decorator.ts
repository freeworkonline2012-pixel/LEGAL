import { SetMetadata } from '@nestjs/common';
import type { UserRole } from '../../database/entities/user.entity';

export const ROLES_KEY = 'roles';

/** RBAC: يقيّد الوصول بالأدوار المحددة (يُقرأ بواسطة RolesGuard) */
export const Roles = (...roles: UserRole[]) => SetMetadata(ROLES_KEY, roles);
